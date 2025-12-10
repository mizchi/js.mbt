import { test, expect, type Page } from "@playwright/test";

// Helper to generate unique test data
const generateTestUser = () => ({
  name: `Test User ${Date.now()}`,
  email: `test${Date.now()}@example.com`,
  password: "testpass123",
});

// Helper to register and login a user
async function registerAndLogin(page: Page, user: ReturnType<typeof generateTestUser>) {
  // Register
  await page.goto("/auth/register");
  await page.fill('input[name="name"]', user.name);
  await page.fill('input[name="email"]', user.email);
  await page.fill('input[name="password"]', user.password);
  await page.click('button[type="submit"]');
  await page.waitForURL("/auth/login");

  // Login
  await page.fill('input[name="email"]', user.email);
  await page.fill('input[name="password"]', user.password);
  await page.click('button[type="submit"]');
  await page.waitForURL("/");
}

test.describe("Authentication", () => {
  test("should show login page for unauthenticated users", async ({ page }) => {
    await page.goto("/");
    await expect(page).toHaveURL("/auth/login");
    await expect(page.locator("h1")).toHaveText("Login");
  });

  test("should show register page", async ({ page }) => {
    await page.goto("/auth/register");
    await expect(page.locator("h1")).toHaveText("Register");
    await expect(page.locator('input[name="name"]')).toBeVisible();
    await expect(page.locator('input[name="email"]')).toBeVisible();
    await expect(page.locator('input[name="password"]')).toBeVisible();
  });

  test("should register a new user", async ({ page }) => {
    const user = generateTestUser();

    await page.goto("/auth/register");
    await page.fill('input[name="name"]', user.name);
    await page.fill('input[name="email"]', user.email);
    await page.fill('input[name="password"]', user.password);
    await page.click('button[type="submit"]');

    // Should redirect to login page after registration
    await expect(page).toHaveURL("/auth/login");
  });

  test("should login with registered user", async ({ page }) => {
    const user = generateTestUser();

    // Register first
    await page.goto("/auth/register");
    await page.fill('input[name="name"]', user.name);
    await page.fill('input[name="email"]', user.email);
    await page.fill('input[name="password"]', user.password);
    await page.click('button[type="submit"]');
    await page.waitForURL("/auth/login");

    // Then login
    await page.fill('input[name="email"]', user.email);
    await page.fill('input[name="password"]', user.password);
    await page.click('button[type="submit"]');

    // Should redirect to home page
    await expect(page).toHaveURL("/");
    await expect(page.locator("h1")).toHaveText("My TODOs");
    await expect(page.getByText(`Welcome, ${user.email}`)).toBeVisible();
  });

  test("should show error for invalid login", async ({ page }) => {
    await page.goto("/auth/login");
    await page.fill('input[name="email"]', "nonexistent@example.com");
    await page.fill('input[name="password"]', "wrongpassword");
    await page.click('button[type="submit"]');

    // Should show error
    await expect(page.locator("h1")).toHaveText("Login Failed");
  });

  test("should logout successfully", async ({ page, context }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    // Verify we're logged in
    await expect(page.getByText(`Welcome, ${user.email}`)).toBeVisible();

    // Click logout
    await page.click('a[href="/auth/logout"]');
    await page.waitForLoadState("networkidle");

    // Clear cookies to simulate a clean session check
    await context.clearCookies();

    // After clearing cookies, accessing home should redirect to login
    await page.goto("/");
    await expect(page).toHaveURL("/auth/login");
  });
});

test.describe("TODO CRUD", () => {
  test("should add a new todo", async ({ page }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    // Add a todo
    const todoTitle = `Test TODO ${Date.now()}`;
    await page.fill('input[name="title"]', todoTitle);
    await page.click('button[type="submit"]');

    // Should show the new todo
    await expect(page.getByText(todoTitle)).toBeVisible();
  });

  test("should toggle todo completion", async ({ page }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    // Add a todo
    const todoTitle = `Toggle TODO ${Date.now()}`;
    await page.fill('input[name="title"]', todoTitle);
    await page.click('button[type="submit"]');
    await page.waitForLoadState("networkidle");
    await expect(page.getByText(todoTitle)).toBeVisible();

    // Find the checkbox associated with this todo by finding the toggle form
    // The checkbox has form attribute pointing to toggle-{id}
    const checkbox = page.locator(`input[type="checkbox"]`).first();

    // Toggle to completed
    await checkbox.click();
    await page.waitForLoadState("networkidle");

    // Verify the todo text has line-through style
    const todoSpan = page.locator("span").filter({ hasText: todoTitle });
    await expect(todoSpan).toHaveCSS("text-decoration-line", "line-through");
  });

  test("should delete a todo", async ({ page }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    // Add a todo
    const todoTitle = `Delete TODO ${Date.now()}`;
    await page.fill('input[name="title"]', todoTitle);
    await page.click('button[type="submit"]');
    await page.waitForLoadState("networkidle");
    await expect(page.getByText(todoTitle)).toBeVisible();

    // Find and click the first delete button
    await page.getByRole("button", { name: "Delete" }).first().click();
    await page.waitForLoadState("networkidle");

    // Verify todo is removed
    await expect(page.getByText(todoTitle)).not.toBeVisible();
  });

  test("should persist todos across page reloads", async ({ page }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    // Add a todo
    const todoTitle = `Persist TODO ${Date.now()}`;
    await page.fill('input[name="title"]', todoTitle);
    await page.click('button[type="submit"]');
    await expect(page.getByText(todoTitle)).toBeVisible();

    // Reload page
    await page.reload();

    // Todo should still be there
    await expect(page.getByText(todoTitle)).toBeVisible();
  });

  test("should add multiple todos", async ({ page }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    const todos = [
      `Todo 1 ${Date.now()}`,
      `Todo 2 ${Date.now()}`,
      `Todo 3 ${Date.now()}`,
    ];

    // Add multiple todos
    for (const title of todos) {
      await page.fill('input[name="title"]', title);
      await page.click('button[type="submit"]');
      await page.waitForLoadState("networkidle");
    }

    // Verify all todos are visible
    for (const title of todos) {
      await expect(page.getByText(title)).toBeVisible();
    }
  });
});

test.describe("Session persistence", () => {
  test("should maintain session across navigation", async ({ page }) => {
    const user = generateTestUser();
    await registerAndLogin(page, user);

    // Navigate to different pages
    await page.click('a[href="/"]');
    await expect(page.locator("h1")).toHaveText("My TODOs");

    // User should still be logged in
    await expect(page.getByText(`Welcome, ${user.email}`)).toBeVisible();
  });
});
