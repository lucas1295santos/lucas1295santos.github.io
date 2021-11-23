import React, { Component, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import Markdown from "react-markdown";
import style from "../post.css";
import rehypeRaw from "rehype-raw";
import gfm from "remark-gfm";

function Post() {
  let { id } = useParams();
  const path = id + "/" + id + ".md";
  const [post, setPost] = useState("");

  useEffect(() => {
    import("../posts/" + path).then((res) => {
      fetch(res.default)
        .then((res) => res.text())
        .then((res) => setPost(res));
    });
  });

  return (
    <div className="reactMarkDown">
      <Markdown
        rehypePlugins={[rehypeRaw]}
        remarkPlugins={[gfm]}
        transformImageUri={(uri) => "post/" + uri}
      >
        {post}
      </Markdown>
    </div>
  );
}
export default Post;
