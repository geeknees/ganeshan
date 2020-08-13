require 'logger'
require 'active_support'
require 'coderay'
require 'pg'

require 'ganesh/config'
require 'ganesh/error'
require 'ganesh/explainer'
require 'ganesh/json_logger'
require 'ganesh/version'

ActiveSupport.on_load :active_record do
  require 'active_record/connection_adapters/postgresql_adapter'
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Ganesh::Explainer
end
