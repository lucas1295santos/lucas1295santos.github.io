import logo from './logo.svg';
import './App.css';
import React from 'react'
import NavigationBar from './components/navigationBar'
import 'bootstrap/dist/css/bootstrap.min.css';
import "./home.css";
import PostCardGroup from './components/postCardGroup';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <NavigationBar/>
        <PostCardGroup/>
      
      </header>
    </div>
  );
}

export default App;
