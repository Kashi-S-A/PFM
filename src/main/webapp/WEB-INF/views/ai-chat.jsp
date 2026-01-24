<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Finance AI Assistant</title>

<style>
*{box-sizing:border-box;font-family:'Segoe UI',system-ui,sans-serif}
body{margin:0;background:#f1f5f9}

.ai-chat-container{
  width:380px;height:520px;background:#fff;border-radius:18px;
  box-shadow:0 20px 50px rgba(0,0,0,.25);
  display:flex;flex-direction:column;overflow:hidden;z-index:9999;
}

.ai-header{
  background:linear-gradient(135deg,#2563eb,#1e40af);
  color:#fff;padding:14px;text-align:center;font-weight:700;
}

.ai-messages{
  flex:1;padding:16px;overflow-y:auto;background:#f8fafc;
  display:flex;flex-direction:column;gap:10px;
}

.msg{
  max-width:78%;
  padding:12px 14px;
  border-radius:18px;
  font-size:14px;
  line-height:1.6;
  animation:fadeIn .2s ease;
  word-wrap:break-word;
}

.msg.user{
  background:linear-gradient(135deg,#2563eb,#1d4ed8);
  color:#fff;margin-left:auto;
  border-bottom-right-radius:6px;
  box-shadow:0 8px 18px rgba(37,99,235,.28);
}

.msg.ai{
  background:#f1f5f9;color:#0f172a;margin-right:auto;
  border-bottom-left-radius:6px;
  border:1px solid rgba(15,23,42,.06);
  box-shadow:0 8px 18px rgba(0,0,0,.08);
  width:100%;
  max-width:100%;
}

.msg.ai .typing{
  font-size:12px;color:#64748b;opacity:.9;margin-bottom:8px;
}

.msg.ai .ai-text{
	white-space: pre-wrap;
	word-break: break-word;
	line-height: 1.65;
}

.section-title{
  font-weight:800;
  margin:10px 0 6px;
}

.bullet{
  display:block;
  padding-left:14px;
  position:relative;
  margin:6px 0;
}
.bullet:before{
  content:"•";
  position:absolute;left:0;top:0;opacity:.85;
}

.money{
  background: rgba(37,99,235,.10);
  color:#0b3aa8;
  padding:2px 6px;
  border-radius:10px;
  font-weight:700;
}

.ai-input-area{
  display:flex;gap:10px;padding:12px;
  border-top:1px solid #e5e7eb;background:#fff;
}

.ai-input-area input{
  flex:1;padding:10px 12px;
  border-radius:12px;border:1px solid #cbd5f5;outline:none;
}
.ai-input-area input:focus{
  border-color:#2563eb;
  box-shadow:0 0 0 3px rgba(37,99,235,.15);
}

.ai-input-area button{
  background:#2563eb;color:#fff;border:none;
  border-radius:12px;padding:0 18px;cursor:pointer;font-weight:700;
}

@keyframes fadeIn{from{opacity:0;transform:translateY(4px)}to{opacity:1;transform:translateY(0)}}
</style>
</head>

<body>

<div class="ai-chat-container">
  <div class="ai-header">🤖 Finance AI Assistant</div>

  <div id="messages" class="ai-messages"></div>

  <div class="ai-input-area">
    <input type="text" id="question" placeholder="Ask about expenses, budget, reports..." />
    <button type="button" onclick="send()">Send</button>
  </div>
</div>

<script>
function escapeHtml(s){
  return (s||"").replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
}

function normalizeSpacing(t){
  return (t||"")
    .replace(/\s+([,.:;!?])/g, "$1")
    .replace(/₹\s+/g, "₹")
    .replace(/(\d)\s*,\s*(\d)/g, "$1,$2")
    .replace(/(\d)\s*\.\s*(\d)/g, "$1.$2")
    .replace(/\(\s+/g, "(")
    .replace(/\s+\)/g, ")")
    .replace(/[ \t]{2,}/g, " ");
}

function toPrettyHtml(fullText){
  var t = normalizeSpacing(fullText);

  t = t.replace(/\*\*/g, "");
  t = t.replace(/📌/g, "\n📌").replace(/📊/g, "\n📊").replace(/✅/g, "\n✅").replace(/🎯/g, "\n🎯");
  t = t.replace(/\s+•\s+/g, "\n• ");

  // mark money before escaping
  t = t.replace(/₹[\d,]+(\.\d+)?/g, function(m){ return "__MONEY__" + m + "__ENDMONEY__"; });

  var safe = escapeHtml(t);

  safe = safe.replaceAll("__MONEY__", '<span class="money">').replaceAll("__ENDMONEY__", "</span>");

  var lines = safe.split("\n").map(function(x){ return x.trim(); }).filter(function(x){ return x.length; });

  var html = "";
  for(var i=0;i<lines.length;i++){
    var line = lines[i];

    if(line.startsWith("📌") || line.startsWith("📊") || line.startsWith("✅") || line.startsWith("🎯")){
      html += '<div class="section-title">' + line + '</div>';
      continue;
    }

    if(line.startsWith("• ")){
      html += '<span class="bullet">' + line.substring(2) + '</span>';
      continue;
    }

    // numbered list -> bullet
    if(/^\d+\.\s+/.test(line)){
      html += '<span class="bullet">' + line.replace(/^\d+\.\s+/, "") + '</span>';
      continue;
    }

    html += '<div>' + line + '</div>';
  }

  return html || "<div>…</div>";
}

function send(){
  var input = document.getElementById("question");
  var q = input.value.trim();
  if(!q) return;

  var chat = document.getElementById("messages");

  var userDiv = document.createElement("div");
  userDiv.className = "msg user";
  userDiv.textContent = q;
  chat.appendChild(userDiv);

  var aiDiv = document.createElement("div");
  aiDiv.className = "msg ai";
  aiDiv.innerHTML = '<div class="typing">Thinking…</div><div class="ai-text"></div>';
  chat.appendChild(aiDiv);

  var aiText = aiDiv.querySelector(".ai-text");
  var typing = aiDiv.querySelector(".typing");

  chat.scrollTop = chat.scrollHeight;
  input.value = "";

  var url = "${pageContext.request.contextPath}/ai/ask-stream?question=" + encodeURIComponent(q);
  var es = new EventSource(url);

  var buffer = "";
  var lastRender = 0;
  var RENDER_MS = 120;

  function render(force){
    var now = Date.now();
    if(!force && (now - lastRender) < RENDER_MS) return;
    lastRender = now;
    aiText.innerHTML = toPrettyHtml(buffer);
    chat.scrollTop = chat.scrollHeight;
  }

  es.onmessage = function(e){
    const token = e.data ?? "";

    // ✅ Add space ONLY when needed
    const last = buffer.length ? buffer[buffer.length - 1] : "";

    const needsSpace =
      last &&
      last !== "\n" &&
      !/\s/.test(last) &&
      !/^[,.:;!?)]/.test(token) &&
      !/[('₹]/.test(last) &&
      !/^\d/.test(token);

    if (needsSpace) buffer += " ";

    buffer += token;

    aiText.textContent = buffer; 
    chat.scrollTop = chat.scrollHeight;
  };

  es.onerror = function(){
    es.close();
    render(true);
    if(typing) typing.remove();
  };
}

document.getElementById("question").addEventListener("keydown", function(e){
  if(e.key === "Enter") send();
});
</script>

</body>
</html>
