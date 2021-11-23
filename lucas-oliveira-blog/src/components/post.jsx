import React, { Component, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import Markdown from "react-markdown";
import style from "../post.css";
import rehypeRaw from "rehype-raw";
import gfm from "remark-gfm";
import CodeBlock from "./codeBlock";
import { prism } from "react-syntax-highlighter/dist/esm/styles/prism";
import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";

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
        components={{
          code({ node, inline, className, children, ...props }) {
            const match = /language-(\w+)/.exec(className || "");
            return !inline && match ? (
              <SyntaxHighlighter
                children={String(children).replace(/\n$/, "")}
                style={prism}
                language={match[1]}
                PreTag="div"
                {...props}
              />
            ) : (
              <code className={className} {...props}>
                {children}
              </code>
            );
          },
        }}
      >
        {post}
      </Markdown>
    </div>
  );
}
export default Post;
