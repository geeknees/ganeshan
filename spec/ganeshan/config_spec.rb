RSpec.describe Ganeshan do
  it { should respond_to :enabled }
  it { should respond_to :enabled= }
  it { should respond_to :logger }
  it { should respond_to :logger= }
  it { should respond_to :connection }
  it { should respond_to :connection= }
end
