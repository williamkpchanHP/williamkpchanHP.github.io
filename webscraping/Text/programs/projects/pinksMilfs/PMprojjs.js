
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
  if(testkey == '6'){ nextImg();}
  if(testkey == '4'){ prevImg();}
  if(testkey == '8'){ foreward();}
  if(testkey == '2'){ backward();}
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
const imgHeader = "<img src='http://www.pinksmilfs.com/content/lady-sonia/galleries/"
const imgMidtxt = "/full/"
const imgTailer = ".jpg'>"

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
	showImg();
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
	theImgAddr = imgHeader + ImgList[listLen] +  imgMidtxt + imgNo + imgTailer;
	thePointerImg.innerHTML = theImgAddr;
	console.log(theImgAddr);
}

function prevImg() {
	imgNo = imgNo -1;
	if(imgNo < 1){ imgNo = 1;}
	theImgAddr = imgHeader + ImgList[listLen] +  imgMidtxt + imgNo + imgTailer;
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


function init_mypicList() {
	if (localStorage.getItem("savedPicList") === null) {
	  mypicList = [];
	  localStorage.savedPicList = JSON.stringify(mypicList);
	} else{
	  mypicList = JSON.parse(localStorage.savedPicList);
	}
}

function addTo_mypicList() {
  mypicList = JSON.parse(localStorage.savedPicList);
  if (!mypicList.includes(ImgList[listLen])) {
    mypicList.push(ImgList[listLen]);
    mypicList = Array.from(new Set(mypicList))
    localStorage.savedPicList = JSON.stringify(mypicList);
    console.log(mypicList);
  }
}

init_mypicList();
changeImg();
document.body.style.cursor = "none"
