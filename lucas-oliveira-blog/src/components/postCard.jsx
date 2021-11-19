import React, { Component } from "react";
import { Card } from "react-bootstrap";

class PostCard extends React.Component {
  render() {
    return (
      <Card text="dark" className="my-4">
        <Card.Body>
          <Card.Title>{this.props.value.title}</Card.Title>
          <Card.Text>{this.props.value.abstract}</Card.Text>
          <Card.Link href={this.props.value.ref}>Read more...</Card.Link>
          <Card.Footer>{this.props.value.date}</Card.Footer>
        </Card.Body>
      </Card>
    );
  }
}

export default PostCard;
