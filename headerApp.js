function changeCode(thecode) {
     url = "https://williamkpchan.github.io/LibDocs/Random Charts.html" + "?" + thecode;
	window.open(url);
}

$("k").click(function() { changeCode($(this).text()) });
window.scrollTo(0,(document.body.scrollHeight));
