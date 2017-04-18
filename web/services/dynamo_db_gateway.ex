defmodule Events.DynamoDbGateway do
  @config DynamoDB.Config.new("127.0.0.1", 8000)
  @table_name "Example"

  def create_table do
    DynamoDB.create_table(config,
    [
      %{AttributeName: "Id", AttributeType: "S"}
    ],
    @dbname,
    [
      %{AttributeName: "Id", KeyType: "HASH"}
    ],
    %{ReadCapacityUnits: 1, WriteCapacityUnits: 1}) == :ok
  end

  def get(item) do
    DynamoDB.get_item(@config, item, @table_name)
  end

  def put(item) do
    DynamoDB.put_item(@config, item, @table_name)
  end
end
