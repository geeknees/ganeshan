RSpec.describe Ganeshan::JsonLogger do
  before do
    Ganeshan.logger = Logger.new('/dev/null')
  end

  let(:sql) do
    'SELECT `products`.* FROM `products`'
  end

  let(:explain) do
    [
      {
        "line": 1,
        "QUERY PLAN": "Seq Scan on products  (cost=0.00..22.00 rows=1200 width=40)"
      }
    ]
  end

  it "returns log" do
    log = nil

    Ganeshan.logger.formatter = lambda do |_, _, _, msg|
      log = msg
    end

    Ganeshan::JsonLogger.log(sql: sql, explain: explain)

    output = <<~JSON.strip
      {
        "sql": "SELECT `products`.* FROM `products`",
        "explain": [
          {
            "line": 1,
            "QUERY PLAN": "Seq Scan on products  (cost=0.00..22.00 rows=1200 width=40)"
          }
        ]
      }
    JSON
    expect(log).to eq(CodeRay.scan(output, :json).terminal)
  end
end
