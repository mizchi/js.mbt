///| Generated types for type checking

///|
pub(all) struct User_address {
  street : String
  city : String
  zip_code : String
  country : String?
}

///|
pub(all) struct User {
  id : Int
  name : String
  email : String
  age : Int?
  roles : Array[String]
  address : User_address
  tags : Array[String]?
}
