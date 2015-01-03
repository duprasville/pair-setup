actions :checkout
default_action :checkout

attribute :path, :name_attribute => true, :kind_of => String, :required => true
attribute :repository, :kind_of => String, :required => true