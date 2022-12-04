module Ganeshan
  module Explainer
    def exec_query(*args, **kwargs)
      p args
      _with_explain(sql: args.first, binds: args[2]) do
        super
      end
    end

    private

    def _with_explain(sql:, binds:)
      begin
        if Ganeshan.enabled && sql =~ /\A\s*SELECT\b/i
          conn = Ganeshan.connection || raw_connection

          type_casted_binds = if binds
                                type_casted_binds(binds)
                              else
                                []
                              end

          if type_casted_binds.empty?
            exp = conn.query("EXPLAIN #{sql}").to_a
          else
            exp = conn.query("EXPLAIN #{sql}", type_casted_binds).to_a
          end

          _validate_explain(sql: sql, exp: exp)
        end
      rescue StandardError => e
        Ganeshan.logger.error("#{e}\n\t#{e.backtrace.join("\n\t")}")
      end

      yield
    end

    def _validate_explain(sql:, exp:)
      Ganeshan::JsonLogger.log(
        sql: sql,
        explain: exp,
      )
    end
  end
end
