# transactions-server
Server for the Android app

## The Application
The application represents a simple transactions app. There is only one account, which contains a list of transactions.
The transaction has fields: Value, Kind and Date.

App futures:
- editing a transaction (add, remove and edit)
- list and detail of transactions
- Synchronise data with server

## The Node.JS server
Server provides API that is defined by this Google protobuf definition:

[`accountDelta.proto`](https://github.com/AntDek/transactions-server/blob/master/app/accountDelta.proto)

Also server proveds login and authentication by JWT
