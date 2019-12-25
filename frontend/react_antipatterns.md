# React Antipatterns

[How to note React: common anti-patterns and gotchas in React](https://codeburst.io/how-to-not-react-common-anti-patterns-and-gotchas-in-react-40141fe0dcd)

- forgetting to bind (just use arrow functions)
- using indexes for keys can be dangerous. keep keys: - unique - stable - predictable (not generated randomly)
- be careful about setting state equal to props, only put that in `componentWillReceiveProps`
