
		var startTime=0;
		var maxTime=178;
		var trialCnt=0;
		var maxTrials=128;
		var context;
		var loop;
		var idx=0;
		var holder=0;
		var round=1;
	
		var keysDown = {};
		var getKeyPress = function(e) {

			if (e.keyCode == 49 || e.keyCode == 50) {
				keysDown[e.keyCode] = true;
			}
		}



		var throw1to2 = new Array();
		var basePath = "imgs/1to2/1to2-";
		for (var i=1; i<9; i++) {
			var img = new Image();
			img.src = basePath + i + '.bmp';
			throw1to2.push(img);
		}


		var throw1to3 = new Array();
		var basePath = "imgs/1to3/1to3-";
		for (var i=1; i<10; i++) {
			var img = new Image();
			img.src = basePath + i + '.bmp';
			throw1to3.push(img);
		}

		var throw2to3 = new Array();
		var basePath = "imgs/2to3/2to3-";
		for (var i=1; i<8; i++) {
			var img = new Image();
			img.src = basePath + i + '.bmp';
			throw2to3.push(img);
		}

		var throw2to1 = new Array();
		var basePath = "imgs/2to1/2to1-";
		for (var i=1; i<8; i++) {
			var img = new Image();
			img.src = basePath + i + '.bmp';
			throw2to1.push(img);
		}

		var throw3to1 = new Array();
		var basePath = "imgs/3to1/3to1-";
		for (var i=1; i<10; i++) {
			var img = new Image();
			img.src = basePath + i + '.bmp';
			throw3to1.push(img);
		}

		var throw3to2 = new Array();
		var basePath = "imgs/3to2/3to2-";
		for (var i=1; i<9; i++) {
			var img = new Image();
			img.src = basePath + i + '.bmp';
			throw3to2.push(img);
		}

		var start = new Array();
		var img = new Image();
		img.src = "imgs/start/start.bmp";
		start.push(img)


		var path = [throw1to2, throw2to3, throw3to2, throw2to3, throw3to1, throw1to3, throw3to1, throw1to2, throw2to1];
		var currPath=0;	
		var imgSet = start;


		var paths = [[false,throw1to2,throw1to3],[throw2to1, false, throw2to3],[throw3to1, throw3to2, false]];


		function init() {
			var canvas = document.getElementById('canvas');
			context = canvas.getContext('2d');

			round=1;
			playRound();

		}


		function playRound() {
			idx=0;
			holder=0;
			trialCnt=0;
			roundLabel = "Round " + round;
			startTime = new Date();
			imgSet = start;
			showImg();
			context.font = "40px Arial";
			context.fillText(roundLabel,350,30);
			
			

			loop = setInterval(showImg,100);		
			//setInterval(throwBall,1000);
		}
	
		function throwBall() {
	
			var throwFrom = holder;		
			var throwTo;

			if (holder==0) {

				if (new Date()-startTime > 2000) {
					holder=1;
					startTime = new Date();
					return;
				}
				return;
			} else
			if (holder==2) {

					addEventListener("keydown",getKeyPress);
					if (49 in keysDown) {
						throwTo=1;
					}
					else if (50 in keysDown) {
						throwTo=3;
					} else {	
						return;
					}	
					
					removeEventListener("keydown",getKeyPress);

					keysDown={};	
						
			}
			else {
				var wait = trialCnt==0 ? 200 : randomFromTo(500,3500);
				var ct = new Date();
				while (new Date() - ct < wait) { };
				keysDown={};
				
				var ft = 0;0

				var throwChoice = Math.random() - ft;
				if (throwChoice<0.5) {
					throwTo = holder==1 ? 3 : 1;
				} else {
					throwTo=2;
				};
			}
			holder = throwTo;
			trialCnt++;
			keysDown={};
			imgSet=paths[throwFrom-1][throwTo-1];
			idx=0;
		}



		function showImg() {
			if (idx>=imgSet.length) { 
				idx=imgSet.length-1; 
				throwBall();
			} else {

			context.save();
			context.drawImage(imgSet[idx],40,0,735,375);
			writeNames();
			context.restore();
			}
			idx++;
			if (holder==2 && idx>3) {
				addEventListener("keydown",getKeyPress);
			}
		
			if (new Date()-startTime > maxTime*1000 || trialCnt > maxTrials) {
				clearInterval(loop);
				if (round==1) { 
					round++; holder=0; playRound(); 
				} else {
					flip();
				}
				
			}
		}	


		function writeNames() {
			context.font = "26px Arial";
			context.fillText(player2,340,450);
			context.fillText(player1,10,150);
			context.fillText(player3,750,150);

		}


function randomFromTo(from, to){
       return Math.floor(Math.random() * (to - from + 1) + from);
    }



