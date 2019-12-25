# BEM

BEM stands for block element modifier and provides a framework for naming and structuring CSS.

source: http://getbem.com/introduction/

## blocks, elements, and modifiers

block: standalone entity that is meaningful on its own - ex: header, container, menu, checkbox, input

element: a part of a block that has no standalone meaning and is semantically tied to its block - ex: menu item, list item, checkbox caption, header title

modifier: a flag on a blok or element. use them to change appearance or behavior. - ex: disabled, highlighted, checked, fied, size big, color yellow

the naming rules tell us to use `block--modifier-value` syntax

```html
<button class="button">
  Normal button
</button>
<button class="button button--state-success">
  Success button
</button>
<button class="button button--state-danger">
  Danger button
</button>
```

```css
.button {
  display: inline-block;
  border-radius: 3px;
  padding: 7px 12px;
  border: 1px solid #d5d5d5;
  background-image: linear-gradient(#eee, #ddd);
  font: 700 13px/18px Helvetica, arial;
}
.button--state-success {
  color: #fff;
  background: #569e3d linear-gradient(#79d858, #569e3d) repeat-x;
  border-color: #4a993e;
}
.button--state-danger {
  color: #900;
}
```

## benefits

### modularity

block styles are never dependent on other elements on a page, so you will never experience problems from cascading.

source: https://www.phase2technology.com/blog/used-and-abused-css-inheritance-and-our-misuse-cascade

ex: the anti-example this would be something like

```css
h2 {
  color: #fd7900;
  font-size: 1.8em;
  line-height: 1.1;
  margin-bottom: 0.3em;
}

.sidebar h2 {
  color: #8cc5e6;
  font-size: 2.2em;
  padding-bottom: 0.2em;
  border-bottom: 1px solid black;
}
```

because now `h2` is dependent on `.sidebar` styles. with BEM, styles are scoped entirely to the block, seen with `button--state-success`.

you also get the ability ot transfer blocks from your finished projects to new ones.

### reusability

composing independent blocks in different ways, and reusing them intelligently, reduces the amount of CSS code you have to maintain. with a set of style guidelines in place, you can build a library of blocks, making your CSS more effective.

### structure

BEM methodolofy gives your CSS code a solid structure that remains simple and easy to understand.
