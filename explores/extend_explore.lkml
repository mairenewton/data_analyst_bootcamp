#example of extending explores
#use case: if you have a team needing to see different fields, but you do not want to repeat the code in creating the same explore with multiple joins

include: "/explores/users_explore.lkml"
include: "/views/users.view.lkml"
include: "/views/derived_tables/user_facts.lkml"


explore: users_extended {

  extends: [users]
  label: "Users Extended Explore"
  fields: [ALL_FIELDS*, -users.age, -users.email]

  join: user_facts {
    type: left_outer
    sql_on: ${user_facts.user_id} = ${users.id};;
    relationship: one_to_one
  }
}
