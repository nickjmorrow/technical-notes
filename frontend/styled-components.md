# Styled Components

## best practices

- can destructure prop function if easier

```js
const Item = styled.div`
    margin: ${({ margin }) => margin}
    // instead of 
    color: ${p => p.color};
`;
```

remember you can extend components

prefer using ui state-oriented props (e.g. "primary", "active", "disabled") over actual css rules as props in order to encapsulate logic
