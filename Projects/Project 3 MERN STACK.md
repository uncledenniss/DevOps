
# STEP 1 – BACKEND CONFIGURATION

```
sudo apt update
sudo apt upgrade
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v

```


## Application Code Setup

```

mkdir Todo
cd Todo
npm init

```


## INSTALL EXPRESS JS AND CREATE THE ROUTES

```

npm install express
touch index.js
npm install dotenv
vim index.js

 const express = require('express');
 require('dotenv').config();

 const app = express();

 const port = process.env.PORT || 5000;

 app.use((req, res, next) => {
 res.header("Access-Control-Allow-Origin", "\*");
 res.header("Access-Control-Allow-Headers",    "Origin, X-Requested-With, Content-Type,  Accept");
 next();
 });

 app.use((req, res, next) => {
 res.send('Welcome to Express');
 });

 app.listen(port, () => {
 console.log(`Server running on port ${port}`)
 });  

node index.js

```

#### Open port 5000 in Security Groups | check this in browser - http://publicIP:5000

#### For Routes

```

mkdir routes
cd routes
touch api.js
vim api.js



const express = require ('express');
const router = express.Router();

router.get('/todos', (req, res, next) => {

});

router.post('/todos', (req, res, next) => {

});

router.delete('/todos/:id', (req, res, next) => {

})

module.exports = router;

```

#### Modules

```

npm install mongoose
mkdir models
cd models
touch todo.js
vim todo.js

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//create schema for todo
const TodoSchema = new Schema({
action: {
type: String,
required: [true, 'The todo text field is required']
}
})

//create model for todo
const Todo = mongoose.model('todo', TodoSchema);

module.exports = Todo;


const express = require ('express');
const router = express.Router();
const Todo = require('../models/todo');

router.get('/todos', (req, res, next) => {

//this will return all the data, exposing only the id and action field to the client
Todo.find({}, 'action')
.then(data => res.json(data))
.catch(next)
});

router.post('/todos', (req, res, next) => {
if(req.body.action){
Todo.create(req.body)
.then(data => res.json(data))
.catch(next)
}else {
res.json({
error: "The input field is empty"
})
}
});

router.delete('/todos/:id', (req, res, next) => {
Todo.findOneAndDelete({"_id": req.params.id})
.then(data => res.json(data))
.catch(next)
})

module.exports = router;  

```


#### MONGODB

```

touch .env
mongodb+srv://kris:<password>@cluster0.4kq6s.mongodb.net/<Dbname>?retryWrites=true&w=majority

const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const routes = require('./routes/api');
const path = require('path');
require('dotenv').config();

const app = express();

const port = process.env.PORT || 5000;

//connect to the database
mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log(`Database connected successfully`))
.catch(err => console.log(err));

//since mongoose promise is depreciated, we overide it with node's promise
mongoose.Promise = global.Promise;

app.use((req, res, next) => {
res.header("Access-Control-Allow-Origin",  "\*");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
next();
});

app.use(bodyParser.json());

app.use('/api', routes);

app.use((err, req, res, next) => {
console.log(err);
next();
});

app.listen(port, () => {
console.log(`Server running on port ${port}`)
});

node index.js

```

#### Check API endpoints with PostMan | http://publicIP:5000/api/todos


## STEP 2 – FRONTEND CREATION     
---

 `npx create-react-app client` 

  `npx create-react-app client`

- #### **React App**

```
      npm install concurrently --save-dev
     
      npm install nodemon --save-dev
      
       "scripts": {
     "start": "node index.js",
     "start-watch": "nodemon index.js",
     "dev": "concurrently \"npm run start-watch\" \"cd client && npm start\""
     },
     ```

      cd client

      vi package.json

    3. Add the key-value pair to  package.json file "proxy": "http://localhost:5000".

 npm run dev    
   cd client

  cd src

  mkdir components

  cd components

  touch Input.js ListTodo.js Todo.js

  vi Input.js

  import React, { Component } from 'react';
  import axios from 'axios';


  class Input extends Component {

  state = {
  action: ""
  }

  addTodo = () => {
  const task = {action: this.state.action}

    if(task.action && task.action.length > 0){
      axios.post('/api/todos', task)
        .then(res => {
          if(res.data){
            this.props.getTodos();
            this.setState({action: ""})
          }
        })
        .catch(err => console.log(err))
    }else {
      console.log('input field required')
    }

  }

  handleChange = (e) => {
  this.setState({
  action: e.target.value
  })
  }

  render() {
  let { action } = this.state;
  return (
  <div>
  <input type="text" onChange={this.handleChange} value={action} />
  <button onClick={this.addTodo}>add todo</  button>
  </div>
  )
  }
  }

  export default Input
  ```


  `cd ../..`

  `npm install axios` 

  `cd src/components`

  `vi ListTodo.js`

 ```
  import React from 'react';

  const ListTodo = ({ todos, deleteTodo }) => {

  return (<ul>
  {
  todos &&
  todos.length > 0 ?
  (
  todos.map(todo => {
  return (
  <li key={todo._id} onClick={() => deleteTodo(todo._id)}>{todo.action}</li>
  )
  })
  )
  :
  (
  <li>No todo(s) left</li>
  )
  }
  </ul>
  )
  }

  export default ListTodo
  ```  

  ```
  import React, {Component} from 'react';
  import axios from 'axios';

  import Input from './Input';
  import ListTodo from './ListTodo';

  class Todo extends Component {

  state = {
  todos: []
  }

  componentDidMount(){
  this.getTodos();
  }

  getTodos = () => {
  axios.get('/api/todos')
  .then(res => {
  if(res.data){
  this.setState({
  todos: res.data
  })
  }
  })
  .catch(err => console.log(err))
  }

  deleteTodo = (id) => {

    axios.delete(`/api/todos/${id}`)
      .then(res => {
        if(res.data){
          this.getTodos()
        }
      })
      .catch(err => console.log(err))

  }

  render() {
  let { todos } = this.state;

    return(
      <div>
        <h1>My Todo(s)</h1>
        <Input getTodos={this.getTodos}/>
        <ListTodo todos={todos} deleteTodo={this.deleteTodo}/>
      </div>
    )

  }
  }

  export default Todo;
  ``` 


  ` cd ..` 

  `vi App.js` 


  ``` 
  import React from 'react';

  import Todo from './components/Todo';
  import './App.css';

  const App = () => {
  return (
  <div className="App">
  <Todo />
  </div>
  );
  }

  export default App;



  vi App.css

  
  ```

```
  .App {
  text-align: center;
  font-size: calc(10px + 2vmin);
  width: 60%;
  margin-left: auto;
  margin-right: auto;
  }

  input {
  height: 40px;
  width: 50%;
  border: none;
  border-bottom: 2px #101113 solid;
  background: none;
  font-size: 1.5rem;
  color: #787a80;
  }

  input:focus {
  outline: none;
  }

  button {
  width: 25%;
  height: 45px;
  border: none;
  margin-left: 10px;
  font-size: 25px;
  background: #101113;
  border-radius: 5px;
  color: #787a80;
  cursor: pointer;
  }

  button:focus {
  outline: none;
  }

  ul {
  list-style: none;
  text-align: left;
  padding: 15px;
  background: #171a1f;
  border-radius: 5px;
  }

  li {
  padding: 15px;
  font-size: 1.5rem;
  margin-bottom: 15px;
  background: #282c34;
  border-radius: 5px;
  overflow-wrap: break-word;
  cursor: pointer;
  }

  @media only screen and (min-width: 300px) {
  .App {
  width: 80%;
  }

  input {
  width: 100%
  }

  button {
  width: 100%;
  margin-top: 15px;
  margin-left: 0;
  }
  }

  @media only screen and (min-width: 640px) {
  .App {
  width: 60%;
  }

  input {
  width: 50%;
  }

  button {
  width: 30%;
  margin-left: 10px;
  margin-top: 0;
  }
  }
  ```


    vi index.css


  ```
  body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
  "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
  sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  box-sizing: border-box;
  background-color: #282c34;
  color: #787a80;
  }

  code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, "Courier New",
  monospace;
  }
  ```


  `cd ../..`

- From Todo directory run: `npm run dev` 













