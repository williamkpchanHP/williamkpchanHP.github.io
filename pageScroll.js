function pageScroll() {
    window.scrollBy(0,1);
    scrolldelay = setTimeout(pageScroll,10);
}

function randomScroll(){
  topicpointer = Math.floor(Math.random() * topicLength)
  window.location = "#topic-" + topicpointer;
  pageScroll();
}
