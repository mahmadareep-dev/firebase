enum QueryOperator {
  equalTo,
  notEqualTo,
  lessThan,
  lessThanOrEqualTo,
  greaterThan,
  greaterThanOrEqualTo,
  whereIn,
  whereNotIn,
  arrayContains,
  arrayContainsAny,
  isNull,
}

class QueryFilter {
  final String field;

  final QueryOperator operator;

  final dynamic value;

  const QueryFilter({required this.field, required this.operator, this.value});
}
