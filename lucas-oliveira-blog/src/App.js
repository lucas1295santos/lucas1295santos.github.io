import './App.css';
import React from 'react'
import NavigationBar from './components/navigationBar'
import 'bootstrap/dist/css/bootstrap.min.css';
import "./home.css";
import Home from './components/home';
import About from './components/about';
import Post  from './components/post';
import NotFound from './components/notFound'
import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";

function App() {
  return <Router>
  <NavigationBar/>
    <Routes>
      <Route exact path="/" element={<Home/>}/>
      <Route path="/about" element={<About/>} />
      <Route path="post/:id" element={<Post />} />
      <Route path="*" element={<NotFound/>}/>
    </Routes>
  </Router>
}

export default App;
