import React, { Component } from "react";
import { Card } from "react-bootstrap";

class PostCard extends React.Component {
  state = {
    title: "Post title",
    abstract: "This is the post i wrote, check it out",
    date: "18/11/2021",
    ref: "https://google.com",
  };

  render() {
    return (
      <Card text="dark" className="my-4">
        <Card.Body>
          <Card.Title>{this.state.title}</Card.Title>
          <Card.Text>{this.state.abstract}</Card.Text>
          <Card.Link href={this.state.ref}>Read more...</Card.Link>
          <Card.Footer>{this.state.date}</Card.Footer>
        </Card.Body>
      </Card>
    );
  }
}

export default PostCard;
