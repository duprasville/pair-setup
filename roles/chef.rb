name "chef"
description "Role for working with chef."

run_list %w[
  role[base]
  recipe[osx::vagrant]
  recipe[osx::virtualbox]
]