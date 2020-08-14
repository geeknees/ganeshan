require 'logger'
require 'active_support'
require 'coderay'
require 'pg'

require 'ganeshan/config'
require 'ganeshan/error'
require 'ganeshan/explainer'
require 'ganeshan/json_logger'
require 'ganeshan/version'

ActiveSupport.on_load :active_record do
  require 'active_record/connection_adapters/postgresql_adapter'
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Ganeshan::Explainer
end
