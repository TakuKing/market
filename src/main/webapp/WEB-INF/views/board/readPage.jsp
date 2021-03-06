<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<%@ include file="/WEB-INF/views/include/header.jsp"%>
<script src="${pageContext.request.contextPath}/resources/res/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/res/js/jquery.easing.1.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/res/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/res/js/jquery.waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/res/js/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/res/js/salvattore.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/res/js/main.js"></script>
<style>
.fileDrop {
  width: 80%;
  height: 300px;
  border: 1px dotted gray;
  background-color: lightslategrey;
  margin: auto;
  
}
.popup{
	position: absolute;
}
.back{
	background-color: gray;
	opacity : 0.5;
	width: 100%;
	height: 300%;
	overflow: hidden;
	z-index: 1101;
}
.front{
	z-index: 1110;
	opacity : 1;
	border : 1px;
	margin :auto;
}
.show{
	position: relative;
	max-width: 1200px;
	max-height: 800px;
	overflow: auto;
}
</style>
</head>
<body>
	<script type="text/javascript" src="/resources/js/upload.js"></script>
	<form role="form" method="post">
		<input type='hidden' name='bno' value="${boardVO.bno }">
		<input type='hidden' name='page' value="${cri.page }">
		<input type='hidden' name='perPageNum' value="${cri.perPageNum }">
		<input type='hidden' name='searchType' value="${cri.searchType }">
		<input type='hidden' name='keyword' value="${cri.keyword }">
	</form>

	<div id="fh5co-main">
		<div class="container">
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
					<h2 style="text-align: center">${boardVO.title}</h2> 
					<input type="hidden" name="title" class="form-control" value="${boardVO.title}" readonly="readonly">
					<div class="fh5co-spacer fh5co-spacer-sm"></div>
					<p><img src="${pageContext.request.contextPath}/displayFile?fileName=${fn:substring(boardVO.files[0],0,12)}${fn:substring(boardVO.files[0],14,fn:length(boardVO.files[0]))}" alt="Free HTML5 template by FREEHTML5.co" class="img-rounded img-responsive"></p>
					<p>조회수 : ${boardVO.viewcnt}</p>
					<p>글쓴이 : ${boardVO.writer}</p>
					<p>내   용 : ${boardVO.content}</p>
					
					<div class = "popup back" style = "display:none;"></div>
					<div id = "popup_front" class = "popup front" style = "display:none;">
						<img id = "popup_img" />
					</div>
					
					<div class = "box-footer">
						<div>
							<hr />
						</div>
						<ul class="mailbox-attachments clearfix uploadedList"></ul>
						<c:if test="${login.email == boardVO.writer}">
							<button class = "btn btn-warning" id="modBoard" type = "submit">modify</button>
							<button class = "btn btn-danger" id="delBoard" type = "submit">delete</button>
						</c:if>
						<button class = "btn btn-primary" id="listBoard" type = "submit">list</button>
					</div>
				</div>
        	</div>
    	</div>
	</div>
	
	<!-- 댓글 추가  -->
	<div class="container">
		<div class="row">
			<div  class="col-md-8 col-md-offset-2">
				<div class="box box-success">
					<div class="box-header">
						<h3 class ="box-title">댓글 추가</h3>
					</div>
					<c:if test="${not empty login}">
						<div class="box-body">
							<label for="exampleInputEmail1">글쓴이</label>
							<input class="form-control" type="text" value="${login.email}" readonly="readonly" placeholder="아이디" id="newReplyWriter">
							<label for="exampleInputEmail1">댓글내용</label>
							<input class="form-control" type="text" placeholder="내용" id="newReplyText">
						</div>
						<!-- box 바디 -->
						<br />
						<div class="box-footer">
							<button type="submit" class="btn btn-primary" id="replyAddBtn">댓글등록</button>
						</div>
					</c:if>
					
					<c:if test="${empty login}">
						<div class="box-body">
						<div><a href="javascript:goLogin();">Login Please</a></div>
						</div>
					</c:if>	
					
				</div>
			</div>
		</div>
	</div>
	<br>
	<!-- 댓글 목록 -->
	<div class="container">
		<div class="row">
			<ul class="timeline col-md-8 col-md-offset-2">
				<li class="time-label" id="repliesDiv"><span class="bg-green">댓글 목록<small id='replycntSmall'>${boardVO.replycnt }</small></span></li>
			</ul>
			
			<div class="text-center">
				<ul id="pagination" class="pagination pagination-sm no-margin">
				</ul>
			</div>
		</div>
	</div>
	<!-- modal 추가 -->
	<div id = "modifyModal" class = "modal modal-primary fade" role = "dialog">
		<div class = "modal-dialog">
			<div class = "modal-content">
				<div class = "modal-header">
					<button type = "button" class = "close" data-dismiss = "modal">&times;</button>
					<h4 class = "modal-title" ></h4>
				</div>
				<div class = "modal-body" data-rno>
					<p>
						<input type = "text" id = "replytext" class = "form-control" />
					</p>
				</div>
				<div class = "modal-footer">
					<button type = "button" class = "btn-info" id = "replyModBtn">수정</button>
					<button type = "button" class = "btn-danger" id = "replyDelBtn">삭제</button>
					<button type = "button" class = "btn-default" data-dismiss = "modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<script>
		function goLogin() {
			location.href ="/user/login";
		}
		$(document).ready(function(){
			
			var formObj = $("form[role='form']");
			console.log(formObj);
			
			$("#modBoard").on("click", function(){
				formObj.attr("action", "/board/modifyPage");
				formObj.attr("method", "get");
				formObj.submit();
			});
			
			$("#delBoard").on("click", function(){
				var replycnt = $('#replycntSmall').html();
				
				replycnt = replycnt.replace('[','');
				replycnt = replycnt.replace(']','');
				
				if(replycnt > 0){
					alert("댓글이 달린 게시물을 삭제 할 수 없습니다.");
					return;
				}
				
				var arr = [];
				$(".uploadedList li").each(function(index){
					arr.push($(this).attr("data-src"));
				});
				if(arr.length>0){
					$.post("/deleteAllFiles",{files:arr},function(){
						
					});
				}
				formObj.attr("action", "/board/removePage");
				formObj.submit();
			});			
			
			$("#listBoard").on("click", function(){
				formObj.attr("method","get");
				formObj.attr("action","/board/list");
				formObj.submit();
			});
			
		});
	</script>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
	<script id="template" type="text/x-handlebars-template">
		{{#each .}}
		<li class="replyLi" data-rno={{rno}}>
				<i class="fa fa-comments bg-blue"></i>
				<div class="timeline-item">
					<span class="time">
						<i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
					</span>
					<h3 class="timeline-header"><strong>{{rno}}</strong>-{{replyer}}</h3>
					<div class="timeline-body">{{replytext}}</div>
					<div class="timeline-footer">
					{{#eqReplyer replyer}}
					<a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">수정</a>
					{{/eqReplyer}}
					</div>
				</div>
		</li>
		{{/each}}
	</script>
	
	<script id="templateAttach" type="text/x-handlebars-template">
	<li data-src = '{{fullName}}'>
		<span class = "mailbox-attachment-icon has-img"><img src = "{{imgsrc}}" alt = "Attachment"></span> 
		<div class = "mailbox-attachment-info">
		<a href = "{{getLink}}" class = "mailbox-attachment-name">{{fileName}}</a>
		</span>
		</div>
	</li>
	</script>
		
	<script>
		Handlebars.registerHelper("eqReplyer", function(replyer, block){
			var accum='';
			if(replyer == '${login.email}'){
				accum += block.fn();
			}
			return accum;
		});
		
		Handlebars.registerHelper("prettifyDate", function(timeValue){
			var dateObj = new Date(timeValue);
			var year = dateObj.getFullYear();
			var month = dateObj.getMonth();
			var date = dateObj.getDate();
			
			return year + "/"+month+"/"+date;
		});
		
		var printData = function(replyArr, target, templateObject){
			var template = Handlebars.compile(templateObject.html());
			var html = template(replyArr);
			$(".replyLi").remove();
			target.after(html);
		}
		var bno = ${boardVO.bno};
		var replyPage = 1;
		var printPaging = function(pageMaker,target){
			var str = "";
			if(pageMaker.prev){
				str += "<li><a href='"+(pageMaker.startPage-1)+"'><<</a></li>";
				
			}
			for(var i = pageMaker.startPage, len=pageMaker.endPage; i<=len; i++){
				var strClass= pageMaker.cri.page == i ? 'class=active' : '';
				str += "<li "+strClass+"><a href='"+i+"'>"+i+"</a></li>";
			}
			if(pageMaker.next){
				str += "<li><a href='"+(pageMaker.endPage+1)+"'>>></a></li>";
			}
			target.html(str);			
		};
		
		$("#repliesDiv").on("click",function(){
			if($(".timeline li").size()>1)
			{
				return;
			}
			getPage("/replies/" + bno + "/1");
		});
		
		$(".pagination").on("click", "li a",function(event){
			event.preventDefault();
			replyPage = $(this).attr("href");
			getPage("/replies/"+bno+"/"+replyPage);
		});
		
		$("#replyAddBtn").on("click",function(){
			var replyerObj = $("#newReplyWriter");
			var replytextObj = $("#newReplyText");
			var replyer = replyerObj.val();
			var replytext = replytextObj.val();
			
			$.ajax({
				type:'POST',
				url:'/replies/',
				headers:{
						"Content-Type":"application/json",
						"X-HTTP-Method-Override":"POST"},
				dataType:'text',
				data:JSON.stringify({bno:bno , replyer:replyer , replytext:replytext }),
				success:function(result){
					console.log("result :" + result);
					if(result == 'SUCCESS'){
						alert("등록 되었습니다.");
						replyPage =1;
						getPage("/replies/"+bno+"/"+replyPage);
						replytextObj.val("");
						}
				}});
		});
		
		$(".timeline").on("click",".replyLi", function(event){
			var reply = $(this);
			$("#replytext").val(reply.find('.timeline-body').text());
			$(".modal-title").html(reply.attr("data-rno"));
		});
		
		$("#replyModBtn").on("click", function(){
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type:'PUT',
				url:'/replies/'+rno,
				headers:{
						"Content-Type":"application/json",
						"X-HTTP-Method-Override":"PUT"},
				dataType:'text',
				data:JSON.stringify({replytext:replytext}),
				success:function(result){
					console.log("result :" + result);
					if(result == 'SUCCESS'){
						alert("수정 되었습니다.");
						getPage("/replies/"+bno+"/"+replyPage);
						}
				}});
		});
		
		$("#replyDelBtn").on("click", function(){
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type:'DELETE',
				url:'/replies/'+rno,
				headers:{
						"Content-Type":"application/json",
						"X-HTTP-Method-Override":"DELETE"},
				dataType:'text',
				success:function(result){
					console.log("result :" + result);
					if(result == 'SUCCESS'){
						alert("삭제 되었습니다.");
						getPage("/replies/"+bno+"/"+replyPage);
						}
				}});
		});
		
		//  파일 조회
		var bno = ${boardVO.bno};
		var template = Handlebars.compile($("#templateAttach").html());
		
		$.getJSON("/board/getAttach/"+bno, function(list){
			$(list).each(function(){
				var fileInfo = getFileInfo(this);
				var html = template(fileInfo);
				$(".uploadedList").append(html);
				
			});
		});

		
		$(".uploadedList").on("click", ".mailbox-attachment-info a",  function(event){
			var fileLink = $(this).attr("href");

			if(checkImageType(fileLink)){
				
				event.preventDefault();
				
				var imgTag = $("#popup_img");
				imgTag.attr("src", fileLink);
				
				console.log(imgTag.attr("src"));
				
				$(".popup").show('slow');
				imgTag.addClass("show");
			}
		});
		
		$("#popup_img").on("click", function(){
			$(".popup").hide('slow');
		});
		
		
		// ajax 댓글 수 갱신
		function getPage(pageInfo){
			$.getJSON(pageInfo, function(data){
				printData(data.list, $("#repliesDiv"), $("#template"));
				printPaging(data.pageMaker, $(".pagination"));
				$("#modifyModal").modal("hide");
				$("#replycntSmall").html("[ " +data.pageMaker.totalCount+"]");
			});
		}
	
	</script>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>
