http = require('http')

messages = [
  'You are very special.'
  'You can do anything you put your mind to.'
  'You are terrific.'
  'You are smart.'
  'You are one of a kind.'
  'You have a great sense of humor.'
  'Your hair looks amazing.'
  'Everybody likes you.'
  'Even if not everybody likes you, I like you.'
  'Have a good day!'
  'You will succeed.'
  'Never give up.'
  'I believe in you.'
  'Great job!'
  'You deserve a high five.'
  'All the good things they said about you were true, if not understatements!'
  "You're on the verge of something amazing."
  "I sincerely believe that Joe Esposito wrote his smash hit \"You're the Best\" about you." # TODO: use appropriate pronouns when running as Joe Esposito's mom
]

connectionIndex = 0

server = http.createServer (request, response) ->
  if request.url is '/'
    response.end """
    <html><body>
    <style>
      .hidden {
        display: none;
      }
    </style>
    <script>
      function updateUsage() {
        var nameField = document.getElementById('name');
        var instructions = document.getElementById('instructions');
        var namePlaceholder = document.getElementById('you');
        namePlaceholder.innerText = nameField.value;
        nameField.className = 'hidden';
        instructions.className = '';
      }
    </script>
    <input id="name" placeholder="Your Name" onchange="updateUsage()" />
    <pre id="instructions" class="hidden">
    brew install expect
    unbuffer curl http://192.168.1.126:5433/<span id="you">YOU</span> -s | while read line ; do echo $line | say ; done
    </pre>
    </body></html>
    """
    return

  connection = ++connectionIndex

  name = request.url.split('/')[1]
  console.log "incoming connection for #{name}'s mom (##{connection})"

  lastIndex = null
  timeout = null
  respond = (message) ->
    if message? or Math.random() < 0.2
      message ?= do ->
        index = lastIndex
        index = Math.floor(Math.random() * messages.length) until index isnt lastIndex
        lastIndex = index
        messages[index]

      response.write "#{message}\n"
      console.log "  ##{connection}: sent: #{message}"
    else
      response.write "\n"

    timeout = setTimeout respond, 5000 + Math.random() * 25000

  respond "Hello, #{name}!"

  request.on 'close', ->
    clearTimeout timeout

PORT = 5433

server.listen PORT, ->
  console.log "mom server running on port #{PORT}"
