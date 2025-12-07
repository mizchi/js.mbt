# MoonBit UI Library

純粋なMoonBitで実装された、React風のVirtual DOMライブラリです。

## 機能

- ✅ **Virtual DOM** - 効率的なDOM更新
- ✅ **Hooks API** - `useState`, `useEffect`, `useMemo`, `useCallback`, `useRef`
- ✅ **SSR (Server-Side Rendering)** - HTML文字列生成
- ✅ **Hydration** - SSRコンテンツのクライアント側復元
- ✅ **State Serialization** - Qwik風の状態シリアライズ（JS特化）
- ✅ **Type-safe Props** - 型安全なプロパティ

## 対応ターゲット

**JavaScript (Browser) のみ**

このライブラリはブラウザDOM専用です。詳細は [TARGET_SUPPORT.md](./TARGET_SUPPORT.md) を参照してください。

## テスト実行

```bash
# ✅ 正しい - jsターゲットでテスト
moon test --target js --package mizchi/js/_experimental/ui

# 全104テストが成功します
```

## 使用例

詳細は [RESUMABLE_STATE.md](./RESUMABLE_STATE.md) を参照してください。

## ドキュメント

- [RESUMABLE_STATE.md](./RESUMABLE_STATE.md) - 状態シリアライズの使い方
- [BACKEND_DEPENDENCY_ANALYSIS.md](./BACKEND_DEPENDENCY_ANALYSIS.md) - バックエンド依存性分析
- [TARGET_SUPPORT.md](./TARGET_SUPPORT.md) - ターゲットサポート情報
