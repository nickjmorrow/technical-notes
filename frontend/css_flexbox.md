# CSS Flexbox

## [Solved by Flexbox](https://philipwalton.github.io/solved-by-flexbox/)

- sticky footer

```html
<body class="Site">
  <header>…</header>
  <main class="Site-content">…</main>
  <footer>…</footer>
</body>
```

```css
.Site {
  display: flex;
  min-height: 100vh;
  flex-direction: column;
}

.Site-content {
  flex: 1;
}
```

- better, simpler grid systems
- holy grail layout
