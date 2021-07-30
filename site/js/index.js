var storedState = localStorage.getItem('elm-todo-save');
var startingState = storedState ? JSON.parse(storedState) : null;

var flags = { locationHref: location.href, model: startingState }

var app = Elm.Main.init({
  flags: flags,
  node: document.getElementById('root')
});

app.ports.setStorage.subscribe(function (state) {
  localStorage.setItem('elm-todo-save', JSON.stringify(state));
});

// Inform app of browser navigation (the BACK and FORWARD buttons)
window.addEventListener('popstate', function () {
  app.ports.onUrlChange.send(location.href);
});

