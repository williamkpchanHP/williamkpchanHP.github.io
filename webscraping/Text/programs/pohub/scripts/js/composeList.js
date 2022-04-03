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
  if(testkey == '/'){ clr_RmvList();}
}

function getChar(event) {
  if (event.which!=0 && event.charCode!=0) {
    return String.fromCharCode(event.which)   // the rest
  } else {
    return null // special key
  }
}

var thePointerImg = document.querySelector('.imagearea');



var listlength = ImgList.length, timer = 15000;
listPointer = 0
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
  if (listPointer > 0) { listPointer = listPointer - 1; }
  else { listPointer = ImgList.length-1; };
  showList();
};
function backward() {
  if (listPointer < ImgList.length-1) { listPointer = listPointer + 1; showList(); };
}
function foreward() {
  if (listPointer > 0) { listPointer = listPointer - 1; showList(); };
}
function pause() {
  clearInterval(myVar);
}
function continU() {
  myVar = setInterval(changeImg, timer); foreward();
}
function showList() {
  header = '<img class="lazy" src=' + baseAddr+ ImgList[listPointer];
  displayImg = "";
  for(var i=1; i<17; i++){displayImg = displayImg + header+ i + '_o.jpg><br>'}
  thePointerImg.innerHTML = displayImg
}
function nextImg() {
  imgNo = imgNo +1;
  if(imgNo > 16){ imgNo = 16;}
  theImgAddr = imgHeader + ImgList[listPointer] +  FormatNumberLength(imgNo) + imgTailer;
  thePointerImg.innerHTML = theImgAddr;
  console.log(theImgAddr);
}

function showthumbs() {
  imgNos = 0
  theImgAddr = ""
  for (var imgNos = 1; imgNos <= 18; imgNos++) {
  temptheImgAddr = imgHeader + ImgList[listPointer] +  FormatNumberLength(imgNos) + imgsTailer;
  theImgAddr = theImgAddr + temptheImgAddr 
  }
  thePointerImg.innerHTML = theImgAddr;
  console.log(theImgAddr);

}

function prevImg() {
  imgNo = imgNo -1;
  if(imgNo < 1){ imgNo = 1;}
  theImgAddr = imgHeader + ImgList[listPointer] +  FormatNumberLength(imgNo) + imgTailer;
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
  var imgAdr = ImgList[listPointer];
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
  if (!mypicList.includes(ImgList[listPointer])) {
    mypicList.push(ImgList[listPointer]);
    mypicList = Array.from(new Set(mypicList)) //Create an Array from a String
    localStorage.savedPicList = JSON.stringify(mypicList);
    //alert("this image has been added to mypicList")
    //console.log(mypicList);
  }
}

function addTo_RmvList() {
  toBeRmvList = JSON.parse(localStorage.toRmvList);
  // check if the image already incluede
  if (!toBeRmvList.includes(ImgList[listPointer])) {
    toBeRmvList.push(ImgList[listPointer]);
    toBeRmvList = Array.from(new Set(toBeRmvList)) //Create an Array from a String
    localStorage.toRmvList = JSON.stringify(toBeRmvList);
    //alert("this image has been added to toBeRmvList")
    //console.log(toBeRmvList);
  }
}
function show_RmvList() {
  toBeRmvList = JSON.parse(localStorage.toRmvList);
  console.log(toBeRmvList);
  thePointerImg.innerHTML = escapeHtml(JSON.stringify(toBeRmvList));
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

$(document).ready(function() {
  init_AllList();
  changeImg();
  document.body.style.cursor = "none"
});

//https://www.pichunter.com/gallery/3697619/Bea_Cummins_Gets_What_She
//https://cdn.pichunter.com/369/7/3697619/3697619_16_o.jpg
//pichunterList.html
//D:\Dropbox\MyDocs\R misc Jobs\webscraping\Text\programs\pohub\scripts

