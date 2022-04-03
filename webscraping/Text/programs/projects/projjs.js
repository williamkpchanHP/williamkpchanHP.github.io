
function chkKey() {
  var testkey = getChar(event);
  if(testkey == 'b'){ backward();}
  if(testkey == 'f'){ foreward();}
  if(testkey == 'p'){ pause();}
  if(testkey == 'c'){ continU();}
  if(testkey == 's'){ showMov();}
  if(testkey == 'd'){ nextImg();}
  if(testkey == 'v'){ prevImg();}
  if(testkey == '+'){ addTo_mypicList();}
  if(testkey == '-'){ addTo_RmvList();}
  if(testkey == '*'){ show_RmvList();}
}

function getChar(event) {
  if (event.which!=0 && event.charCode!=0) {

    return String.fromCharCode(event.which)
  } else {
    return null // special key
  }
}



var listLen = ImgList.length, timer = 120000;
var imgNo = 1;
const imgHeader = "<img src='https://cdn.pornpics.com/pics/"
const imgTailer = "big.jpg'>"
const imgsTailer = ".jpg' style='width: 25%; display: inline;'>"


thePointerImg = document.querySelector('.imagearea');

// Generate a number
function shuffle(array) {
    var i = ImgList.length, j = 0, temp;
    while (i--) {
        j = Math.floor(Math.random() * (i+1)); temp = ImgList[i];
        ImgList[i] = ImgList[j]; ImgList[j] = temp;
    }
    return ImgList;
}

ImgList = shuffle(Array.from(Array(ImgList.length).keys()));

function changeImg() {
	if (listLen >= ImgList.length - 1) {
		listLen = 0;
	} else if (listLen < 0) {
		listLen = ImgList.length - 1;
	} else {
		listLen = listLen + 1;
	};
	imgNo = 0;
	showthumbs();
};
function backward() {
	listLen = listLen - 2;
	changeImg();
}
function foreward() {
	changeImg();
}
function pause() {
	clearInterval(myVar);
}
function continU() {
	myVar = setInterval(changeImg, timer);
	foreward();
}
function showImg() {
	nextImg();
}

function nextImg() {
	imgNo = imgNo +1;
	if(imgNo > 16){ imgNo = 16;}
	theImgAddr = imgHeader + ImgList[listLen] +  FormatNumberLength(imgNo) + imgTailer;
	thePointerImg.innerHTML = theImgAddr;
	console.log(theImgAddr);
}

function showthumbs() {
	imgNos = 0
	theImgAddr = ""
	for (var imgNos = 1; imgNos <= 18; imgNos++) {
	temptheImgAddr = imgHeader + ImgList[listLen] +  FormatNumberLength(imgNos) + imgsTailer;
	theImgAddr = theImgAddr + temptheImgAddr 
	}
	thePointerImg.innerHTML = theImgAddr;
	console.log(theImgAddr);

}

function prevImg() {
	imgNo = imgNo -1;
	if(imgNo < 1){ imgNo = 1;}
	theImgAddr = imgHeader + ImgList[listLen] +  FormatNumberLength(imgNo) + imgTailer;
	thePointerImg.innerHTML = theImgAddr;
}


function FormatNumberLength(num) {
    var r = "" + num;
    while (r.length < 2) {
        r = "0" + r;
    }
    return r;
}
function showMov() {
	var imgAdr = ImgList[listLen];
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
  if (!mypicList.includes(ImgList[listLen])) {
    mypicList.push(ImgList[listLen]);
    mypicList = Array.from(new Set(mypicList)) //Create an Array from a String
    localStorage.savedPicList = JSON.stringify(mypicList);
    //console.log(mypicList);
  }
}

function addTo_RmvList() {
  toBeRmvList = JSON.parse(localStorage.toRmvList);
  // check if the image already incluede
  if (!toBeRmvList.includes(ImgList[listLen])) {
    toBeRmvList.push(ImgList[listLen]);
    toBeRmvList = Array.from(new Set(toBeRmvList)) //Create an Array from a String
    localStorage.toRmvList = JSON.stringify(toBeRmvList);
    //console.log(toBeRmvList);
  }
}
function show_RmvList() {
  //toBeRmvList = JSON.parse(localStorage.toRmvList);
  //alert(toBeRmvList)
}

init_AllList();
changeImg();
document.body.style.cursor = "none"
