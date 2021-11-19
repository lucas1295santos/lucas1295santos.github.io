import React, { Component } from "react";
import { Card } from "react-bootstrap";
import { Link } from "react-bootstrap";

class PostCard extends React.Component {
  render() {
    return (
      <Card text="dark" className="my-4" style={{ textAlign: "left" }}>
        <Card.Body>
          <Card.Title style={{ fontSize: "2rem" }}>
            <a href={this.props.value.ref}>{this.props.value.title}</a>
          </Card.Title>
          <Card.Text style={{ fontSize: "1rem" }}>
            {this.props.value.abstract}
          </Card.Text>
          <Card.Footer style={{ fontSize: "1rem" }}>
            Published on: {this.props.value.date}
          </Card.Footer>
        </Card.Body>
      </Card>
    );
  }
}

export default PostCard;
