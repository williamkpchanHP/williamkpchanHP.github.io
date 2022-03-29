listLen = pictList.length, timer = 15000;

if (typeof(shuffleSW) == 'undefined'){shuffleSW = true}

if ( (typeof(showTopicNumber) !== 'undefined') & (shuffleSW == true) ){
    pictList = shuffle(Array.from(Array(pictList.length).keys()));
}

function chkKey() {
  var testkey = getChar(event);
  if(testkey == "b"){ backward();}
  else if(testkey == "5"){ zoomin();}
  else if(testkey == "2"){ zoomout();}
  else if(testkey == "d"){ nextImg();}
  else if(testkey == "v"){ prevImg();}
  else if(testkey == "["){ addTo_mypicList();}
  else if(testkey == "]"){ addTo_RmvList();}
  else if(testkey == "*"){ show_RmvList();}
  else if(testkey == "/"){ clr_RmvList();}

  else if(testkey == "4"){ backward();}
  else if(testkey == 'e'){window.scrollTo(0,document.body.scrollHeight);}
  else if(testkey == "f"){ foreward();}
  else if(testkey == "6"){ foreward();}
  else if(testkey == "j"){ jumpTo();}
  else if(testkey == "l"){
    $('body,html').animate({scrollTop:(divtoc.clientHeight + divtoc.offsetTop-400)}, 1);}

  else if(testkey == "p"){ pause();}
  // else if(testkey == "c"){ continU();}
  else if(testkey == "r"){ showRandomImg();}
  else if(testkey == "s"){ showMov();}
  else if(testkey == 't'){window.location = '#toc';
      window.scrollTo(window.scrollX, window.scrollY - 200);}

  else if(testkey == '8'){window.location = '#toc';
      window.scrollTo(window.scrollX, window.scrollY - 200);}
  else if(testkey == 'T'){window.scrollTo(0,0);}
  else if(testkey == 'B'){window.open("https://williamkpchan.github.io/LibDocs/汉语字典.html");}

  else if(testkey == "K"){ 
    pos = document.getElementsByTagName("body")[0].scrollTop;
    if(typeof bookid == 'undefined') { bookid = $('title').text() }
    storeBookmark(bookid, pos.toString());
  }
  else if(testkey == "k"){
    if(typeof bookid != 'undefined') {loadBookmark(bookid);}
    else{alert("No BookId!")}
  }
  else if(testkey == "L"){ randomWL();}
  else if(testkey == "+"){ addtoWL();}
  else if(testkey == "-"){ rvFmWL();}
  else if(testkey == "a"){ askNum();}
  else if(testkey == "R"){ showRandomMsg(); }
  else if(testkey == 'A'){autoShowImg(imgnotvisitedList.length)}

  else{chkOtherKeys(testkey)} 
}

function getChar(event) {
  if (event.which!=0 && event.charCode!=0) {
    return String.fromCharCode(event.which)   // the rest
  } else {
    return null // special key
  }
}

// Generate a number
function shuffle(array) {
    var i = pictList.length, j = 0, temp;
    while (i--) {
        j = Math.floor(Math.random() * (i+1)); temp = pictList[i];
        pictList[i] = pictList[j]; pictList[j] = temp;
    }
    return pictList;
}

function changeImg() {
    if ((imgpointer > 0) &(imgpointer < listLen-1)) {
        imgpointer = imgpointer + 1;
    } else {
        imgpointer = 0;
    };
    showImg();
};
function backward() {
    if (listLen < pictList.length) {
        listLen = listLen + 1;
        showImg();
    };
}
function foreward() {
    if (listLen > 0) {
        listLen = listLen - 1;
        showImg();
    };
}
function pause() {
    clearInterval(myVar);
}
function continU() {
    myVar = setInterval(changeImg, timer);
    foreward();
}
function showImg() {
    $("#pictList").html(pictList[imgpointer]);
}
function nextImg() {
    imgNo = imgNo +1;
    if(imgNo > 16){ imgNo = 16;}
    theImgAddr = imgHeader + pictList[listLen] +  FormatNumberLength(imgNo) + imgTailer;
    $("#pictList").html(theImgAddr);
    console.log(theImgAddr);
}

function showthumbs() {
    imgNos = 0
    theImgAddr = ""
    for (var imgNos = 1; imgNos <= 18; imgNos++) {
    temptheImgAddr = imgHeader + pictList[listLen] +  FormatNumberLength(imgNos) + imgsTailer;
    theImgAddr = theImgAddr + temptheImgAddr 
    }

    $("#pictList").html(theImgAddr);
    console.log(theImgAddr);

}

function prevImg() {
    imgNo = imgNo -1;
    if(imgNo < 1){ imgNo = 1;}
    theImgAddr = imgHeader + pictList[listLen] +  FormatNumberLength(imgNo) + imgTailer;

    $("#pictList").html(theImgAddr);
}


function FormatNumberLength(num) {
    var r = "" + num;
    while (r.length < 2) {
        r = "0" + r;
    }
    return r;
}
function showMov() {
    var imgAdr = pictList[listLen];
    var start = imgAdr.indexOf("=")+1;
    var end = imgAdr.indexOf('"', start+1);
    var list = imgAdr.substring(start+1, end);
    window.open(list);
}


function init_AllList() {
    if (localStorage.getItem("savedPicList") === null) {
      mypicList = [];
      localStorage.savedPicList = JSON.stringify(mypicList);
    } else{
      mypicList = JSON.parse(localStorage.savedPicList);
    }
    if (localStorage.getItem("toRmvList") === null) {
      toBeRmvList = [];
      localStorage.toRmvList = JSON.stringify(toBeRmvList);
    } else{
      toBeRmvList = JSON.parse(localStorage.toRmvList);
    }
}

function addTo_mypicList() {
  mypicList = JSON.parse(localStorage.savedPicList);
  // check if the image already incluede
  if (!mypicList.includes(pictList[listLen])) {
    mypicList.push(pictList[listLen]);
    mypicList = Array.from(new Set(mypicList)) //Create an Array from a String
    localStorage.savedPicList = JSON.stringify(mypicList);
    //alert("this image has been added to mypicList")
    //console.log(mypicList);
  }
}

function addTo_RmvList() {
  toBeRmvList = JSON.parse(localStorage.toRmvList);
  // check if the image already incluede
  if (!toBeRmvList.includes(pictList[listLen])) {
    toBeRmvList.push(pictList[listLen]);
    toBeRmvList = Array.from(new Set(toBeRmvList)) //Create an Array from a String
    localStorage.toRmvList = JSON.stringify(toBeRmvList);
    //alert("this image has been added to toBeRmvList")
    //console.log(toBeRmvList);
  }
}
function show_RmvList() {
  toBeRmvList = JSON.parse(localStorage.toRmvList);
  console.log(toBeRmvList);
  $("#pictList").html(escapeHtml(JSON.stringify(toBeRmvList)));

  copyStringToClipboard(toBeRmvList);
  alert("listed in console! and copied to clipboard!");
}
function escapeHtml(text) {
    var map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

function clr_RmvList() {
  toBeRmvList = [];
  localStorage.toRmvList = JSON.stringify(toBeRmvList);
  alert("toBeRmvList has been cleared")
}

function copyStringToClipboard (str) {
   var tempElement = document.createElement('textarea');
   tempElement.value = str;
   tempElement.setAttribute('readonly', '');
   tempElement.style = {position: 'absolute', left: '-9999px'};
   document.body.appendChild(tempElement);
   tempElement.select();
   document.execCommand('copy');
   document.body.removeChild(tempElement);
}

function zoomin(){
        var currWidth = $("#pictList").clientWidth;
        $("#pictList").style.width = (currWidth + 100) + "px";
    }
function zoomout(){
        var currWidth = $("#pictList").clientWidth;
        if(currWidth > 100){
            $("#pictList").style.width = (currWidth - 100) + "px";
        }
    }

function showRandomMsg() {
  topicpointer = notvisitedList[Math.floor(Math.random() * notvisitedList.length)];
  $("#proverb").text(topicpointer);
  var index = notvisitedList.indexOf(topicpointer);
  notvisitedList.splice(index, 1);
  if(notvisitedList.length == 0){ notvisitedList = proverbList}
}

function showRandomImg() {
  imgpointer = imgnotvisitedList[Math.floor(Math.random() * imgnotvisitedList.length)];
  $("#pictList").html(imgpointer);
  var index = imgnotvisitedList.indexOf(imgpointer);
  imgnotvisitedList.splice(index, 1);
  console.log(imgpointer)
  if(imgnotvisitedList.length == 0){ imgnotvisitedList = pictList}
}
function autoShowImg(countNumber) {
  console.log("auto")
  if (countNumber > 0) {
    showRandomImg()
    setTimeout(() => autoShowImg(countNumber - 1), 12000)
  }
}

// init_AllList();
repeats = 10;
notvisitedList = proverbList;
showRandomMsg();
imgnotvisitedList = pictList;
showRandomImg();


// document.body.style.cursor = "none"
