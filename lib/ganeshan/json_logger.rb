module Ganeshan
  module JsonLogger
    module_function

    def log(sql:, explain:)
      h = {
        sql: sql,
        explain: explain.each_with_index.map { |r, i| { line: i + 1 }.merge(r) },
      }

      line = CodeRay.scan(JSON.pretty_generate(**h), :json).terminal
      Ganeshan.logger.info(line)
    end
  end
end
