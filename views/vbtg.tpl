<html>
	<head>

		<title>Virtual Ball-Tossing Game</title>

		<script src="js/jquery-1.7.min.js"></script>
		<script src="js/cyberball.js"></script>

		<style type="text/css">
			.page { display: none;
				margin: 30px;
			}
			#p1 { display: block; }
			#letsplay { display: none; }
			
			body { margin: 0px; 
			       font-family: Verdana, Helvetica, Arial, Sans serif;
			}

			h1 { text-align: center; }						

			#canvas { margin-left: 15%; margin-top: 50px; }

		</style>

		<script>

			var cnum = {{ cnum }};
			var pnames = {{!pnames}};
			var ftval;
			
			
			var player1= '';
			var player2='';
			var player3= '';
			
			
			if (cnum==1 || cnum==3) {
				ftval=0.0;
			} else {
				ftval=0.5;
			}
						

			var pages = ['p1','p2','p3','p4','p5'];
			var currentPage=0;
			function flip() {
				var cpID = '#'+pages[currentPage];
				$(cpID).hide();
				currentPage++;
				cpID = '#'+pages[currentPage];
				$(cpID).show();
			}

			Array.prototype.randElem = function() {
				return this.pop([Math.floor(Math.random() * this.length)]);
			}


			function checkName() {
				var playerName=$('#playerName').val();
				if (playerName=='' || !playerName) {
					$('#playerName').val='';
					return;
				} else {
				
					// select two names from pnames that are different
					// from playerName
					
					player1 = playerName;
					while (player1==playerName) {
						player1 = pnames.randElem();
					}
					
					player3 = playerName;
					while (player3==playerName) {
						player3 = pnames.randElem();
					}
									
				
					$('#player2').html('<b>'+playerName+'</b>');
					flip();
					setTimeout(function() { $('#player1').html('Welcome <b>' + player1 + '</b>')}, 5200)
					setTimeout(function() { $('#player3').html('Welcome <b>' + player3 + '</b>'); $('#letsplay').show();}, 10000)
					player2 = playerName;
					setTimeout(playGame,13000);
				}

				
			}

			function playGame() {
				var ct = new Date();
				while (new Date() - ct < 2000) {}
				flip();
				$('#vbtg-title').hide();
				init();
				
			}

			$(document).ready(function () {
				$('#playerName').val('');
			})
		</script>

	</head>

	<body>


	<div>

		<h1 id="vbtg-title">Virtual Ball-Tosing Game</h1>
	</div>


	<div class="page" id="p1">

		<p>MENTAL VISUALIZATION PRACTICE GAME</p>

		<p>This study is testing the effects of mental visualization on social recall ability, like remembering information about your friends, family, and acquaintances. Thus, we need you to practice your mental visualization skills to prepare for the recall task. We have found that the best way to do this is to have you play an online ball tossing game with other participants who are logged on to the system at the same time.</p>

		<p>In a few moments, you will begin playing a ball-tossing game with other students over our network. Several universities in the state of Michigan are taking part in a collaborative investigation of the effects of mental visualization on task performance, with college students participating at several different Universities around the state of Michigan.</p>

		<p>The practice game is very simple and only lasts a few minutes. When the ball is tossed to you, simply press either the "1" key to throw to the player on your left or the "2" key for to throw to the player on your right. When the game is over, the experimenter will give you additional instructions.</p>

		<p>This task is not about performance. The important thing is that you MENTALLY VISUALIZE the entire experience so you are ready for the later task. Imagine what the others look like. What sort of people are they? Where are you playing? Is it warm and sunny or cold and rainy? Create in your mind a complete mental picture of what might be going on if you were playing this game in real life.</p>

		<p>Okay, ready to begin? <input type="button" onclick="flip()" value="Yes I'm ready!"/></p> 


	</div>



	<div class="page" id="p2">
		<p>Please enter your first name and click to join the online game  <input id="playerName" type="text" size="20" value=""></input><input type="button" onclick="checkName()" value="Join the game"/></p>
		
	</div>


	<div class="page" id="p3">

		<div>
			<table>
				<tbody>
					<tr>
						<td>Player 1</td>
						<td><span id="player1">Waiting for player to join <img src="imgs/ajax-loader.gif" /></span></td>
					</tr>
					<tr>
						<td>Player 2</td>
						<td>Welcome <span id="player2"</span></td>
					</tr>
					<tr>
						<td>Player 3</td>
						<td><span id="player3">Waiting for player to join <img src="imgs/ajax-loader.gif" /></span></td>
					</tr>
			
				</tbody>
			</table>
			<h3 id="letsplay">Let's play! <img src="imgs/ajax-loader.gif"/></h3> 
		</div>


	

	</div>

	<div id="p4" class="page">

			<canvas id="canvas" width="900" height="600">
				<p>Your browser doesn't support canvas.</p>
			</canvas>

	</div>


	<div id="p5" class="page">

		<h3>Game Over. Thanks for playing!</h3>
	
	</div>

	</body>

</html>
