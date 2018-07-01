# pasteboard

## quick css reset

```css
* {
  padding: 0;
  margin: 0;
  border: 0;
  outline: 0;
  background: transparent;
  box-sizing: border-box;
  vertical-align: baseline;

  font-family: sans-serif;
  font-family: Helvetica;
  font-family: HelveticaNeue;

  color: black;
  background: white;
}

a {
  text-decoration: none;
}
```

## common css selectors

```css
html, body, main, .App {
  width: 100vw;
  height: 100vvh;
}

.gpu-enabled {
  transform: translateZ(0);
  backface-visibility: hidden;
}

.flex-frame {
  display: flex;
  justify-content: center;
  align-items: center;
}

.flex-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}
```


## html meta

**required files:**

```
favicon.ico
manifest.json
```

**parameters:**

- `NAME`
- `NICKNAME`
- `CANONICAL_URL`
- `DESCRIPTION`
- `THEME_COLOR`
- `BACKGROUND_COLOR`
- `AUTHOR`

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="shortcut icon" href="/favicon.ico">
<link rel="canonical" href="{{CANONICAL_URL}}">

<title>{PUBLIC_NAME}</title>
<meta name="description" content="{{DESCRIPTION}}">

<!-- PWA -->
<link rel="manifest" href="/manifest.json">
<meta name="theme-color" content="{{THEME_COLOR}}">

<!-- iOS WebApp -->
<link rel="apple-touch-icon" href="/favicon.ico">
<meta name="apple-mobile-web-app-title" content="{{NAME}}">
<meta name="apple-mobile-web-app-capable" content="yes">

<!-- Schema.org markup for Google+ -->
<meta itemprop="name" content="{PUBLIC_NAME}">
<meta itemprop="description" content="{{DESCRIPTION}}">
<meta itemprop="image" content="/favicon.ico">

<!-- Twitter Card data -->
<meta name="twitter:card" content="website">
<meta name="twitter:description" content="{{DESCRIPTION}}">
<meta name="twitter:image" content="/favicon.ico">
<meta name="twitter:title" content="{{NAME}}">
<meta name="twitter:creator" content="{{AUTHOR}}">

<!-- Open Graph data -->
<meta property="og:description" content="{{DESCRIPTION}}">
<meta property="og:image" content="/favicon.ico">
<meta property="og:site_name" content="{{NAME}}">
<meta property="og:title" content="{{NAME}}">
<meta property="og:type" content="website">
<meta property="og:url" content="{{CANONICAL_URL}}">
```

## pwa manifest

```json
{
  "short_name": "{{NICKNAME}}",
  "name": "{{NAME}}",
  "author": "{{AUTHOR}}",
  "description": "{{DESCRIPTION}}",
  "homepage_url": "{{CANONICAL_URL}}",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "192x192",
      "type": "image/png"
    }
  ],
  "background": [
    "scripts": []
  ],
  "start_url": "./index.html",
  "display": "standalone",
  "theme_color": "{{THEME_COLOR}}",
  "background_color": "{{BACKGROUND_COLOR}}"
}
```

## machine setup
