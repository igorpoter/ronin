 <%@ extends ronin.RoninTemplate %>
 <%@ params(aPost : db.roblog.Post, prevLink : boolean, nextLink : boolean, canEdit : boolean, viewLink : boolean) %>
 <% uses controller.* %>
 <% uses db.roblog.Comment %>

 <div class="header">${h(aPost.Title)}</div>
 <div class="body">${h(aPost.Body)}</div>
 <% if(prevLink) { %>
     <div class="prevLink"><a href="${urlFor(\ -> Post.prev(aPost))}">Previous post</a></div>
 <% }
    if(nextLink) { %>
     <div class="nextLink"><a href="${urlFor(\ -> Post.next(aPost))}">Next post</a></div>
 <% }
    if(viewLink) { %>
     <div class="viewLink"><a href="${urlFor(\ -> Post.viewPost(aPost))}">
       <% var commentCount = Comment.count(new Comment(){:Post = aPost}) %>
       <% if(commentCount == 0) { %>
       Comment
       <% } else if(commentCount == 1) { %>
       1 comment
       <% } else { %>
       ${commentCount} comments
       <% } %>
       </a>
     </div>
 <% }
    if(canEdit) { %>
     <div class="editLink"><a href="${urlFor(\ -> Admin.editPost(aPost))}">Edit</a></div>
     <div class="deleteLink"><a href="${urlFor(\ -> Admin.deletePost(aPost))}">Delete</a></div>
 <% } %>

 <div class="posted">Posted on ${aPost.Posted}</div>
