#!/usr/bin/env bash
set -e
mkdir -p "."
cat > "settings.gradle" << 'LUMEN_EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = 'LumenAgent'
include ':app'
LUMEN_EOF
mkdir -p "."
cat > "build.gradle" << 'LUMEN_EOF'
plugins {
    id 'com.android.application' version '8.5.2' apply false
}
LUMEN_EOF
mkdir -p "."
cat > "gradle.properties" << 'LUMEN_EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.nonTransitiveRClass=true
LUMEN_EOF
mkdir -p "."
cat > ".gitignore" << 'LUMEN_EOF'
.gradle/
build/
local.properties
.idea/
*.iml
LUMEN_EOF
mkdir -p "app"
cat > "app/build.gradle" << 'LUMEN_EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace 'uz.lumen.agent'
    compileSdk 34

    defaultConfig {
        applicationId 'uz.lumen.agent'
        minSdk 24
        targetSdk 34
        versionCode 1
        versionName '1.0'
    }

    buildTypes {
        release {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
LUMEN_EOF
mkdir -p "app/src/main"
cat > "app/src/main/AndroidManifest.xml" << 'LUMEN_EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:theme="@android:style/Theme.Material.NoActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
LUMEN_EOF
mkdir -p "app/src/main/java/uz/lumen/agent"
cat > "app/src/main/java/uz/lumen/agent/MainActivity.java" << 'LUMEN_EOF'
package uz.lumen.agent;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {

    private WebView web;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setStatusBarColor(Color.parseColor("#050A22"));
        getWindow().setNavigationBarColor(Color.parseColor("#050A22"));

        web = new WebView(this);
        web.setBackgroundColor(Color.parseColor("#050A22"));
        setContentView(web);

        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        s.setMediaPlaybackRequiresUserGesture(false);

        web.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Uri u = request.getUrl();
                if ("file".equals(u.getScheme())) {
                    return false;
                }
                startActivity(new Intent(Intent.ACTION_VIEW, u));
                return true;
            }
        });

        web.loadUrl("file:///android_asset/index.html");
    }

    @Override
    public void onBackPressed() {
        web.evaluateJavascript("window.lumenBack ? window.lumenBack() : false", value -> {
            if (!"true".equals(value)) {
                MainActivity.super.onBackPressed();
            }
        });
    }
}
LUMEN_EOF
mkdir -p "app/src/main/res/values"
cat > "app/src/main/res/values/strings.xml" << 'LUMEN_EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Agent Lumen</string>
</resources>
LUMEN_EOF
mkdir -p "app/src/main/res/drawable"
cat > "app/src/main/res/drawable/ic_launcher.xml" << 'LUMEN_EOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#0B1550"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M30,18m-4,0a4,4 0,1 1,8 0a4,4 0,1 1,-8 0" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M78,18m-4,0a4,4 0,1 1,8 0a4,4 0,1 1,-8 0" />
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M30,34H78A16,16 0 0 1 94,50V68A16,16 0 0 1 78,84H30A16,16 0 0 1 14,68V50A16,16 0 0 1 30,34Z" />
    <path
        android:fillColor="#0A1230"
        android:pathData="M32,46H76A10,10 0 0 1 86,56V64A10,10 0 0 1 76,74H32A10,10 0 0 1 22,64V56A10,10 0 0 1 32,46Z" />
    <path
        android:fillColor="#14142E"
        android:pathData="M34,36L38,24Q54,20 70,24L74,36Z" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M38,52H44A3,3 0 0 1 47,55V61A3,3 0 0 1 44,64H38A3,3 0 0 1 35,61V55A3,3 0 0 1 38,52Z" />
    <path
        android:fillColor="#2DE2FF"
        android:pathData="M64,52H70A3,3 0 0 1 73,55V61A3,3 0 0 1 70,64H64A3,3 0 0 1 61,61V55A3,3 0 0 1 64,52Z" />
</vector>
LUMEN_EOF
mkdir -p "app/src/main/assets"
cat > "app/src/main/assets/config.js" << 'LUMEN_EOF'
window.LUMEN_CONFIG = {
  apiKey: '__GEMINI_API_KEY__',
  model: 'gemini-2.5-flash'
};
LUMEN_EOF
mkdir -p "app/src/main/assets"
cat > "app/src/main/assets/index.html" << 'LUMEN_EOF'
<!doctype html>
<html lang="uz">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover,user-scalable=no">
<title>Agent Lumen</title>
<style>
:root{--bg:#050a22;--bg2:#0b1550;--cy:#2de2ff;--vi:#8c6bff;--bl:#4d8dff;--mu:#9fb0ff}
*{box-sizing:border-box;-webkit-tap-highlight-color:transparent}
html,body{margin:0;height:100%;background:var(--bg);color:#fff;font-family:Inter,'Helvetica Neue',Helvetica,Arial,sans-serif;overflow:hidden}
#app{height:100vh;height:100dvh;display:flex;flex-direction:column;background:radial-gradient(ellipse at 50% 0%,#17308f 0%,var(--bg2) 38%,var(--bg) 80%)}
.scr{flex:1;display:flex;flex-direction:column;padding:calc(env(safe-area-inset-top) + 28px) 24px calc(env(safe-area-inset-bottom) + 24px);overflow-y:auto;animation:fin .35s ease both}
@keyframes fin{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}
h1{font-size:32px;line-height:1.1;margin:18px 0 8px;letter-spacing:-1px}
p.sub{color:var(--mu);font-size:17px;line-height:1.4;margin:0 0 20px}
label.l{display:block;color:var(--mu);font-size:14px;font-weight:700;letter-spacing:2px;margin:18px 0 8px}
input,textarea,select{width:100%;background:rgba(255,255,255,.08);border:2px solid rgba(255,255,255,.15);border-radius:18px;color:#fff;font-size:18px;padding:15px 18px;outline:none;font-family:inherit}
input:focus,textarea:focus{border-color:var(--cy)}
input.bad{border-color:#ff5a5f;animation:shk .3s}
@keyframes shk{25%{transform:translateX(-8px)}75%{transform:translateX(8px)}}
.chips{display:flex;flex-wrap:wrap;gap:10px;margin:14px 0}
.chip{padding:11px 17px;border-radius:999px;border:2px solid rgba(255,255,255,.18);background:rgba(255,255,255,.06);color:#fff;font-size:16px;font-weight:600;font-family:inherit}
.chip.on{background:var(--cy);color:#07102e;border-color:var(--cy)}
.btn{margin-top:auto;padding:17px;border:0;border-radius:20px;font-size:19px;font-weight:800;color:#07102e;background:linear-gradient(135deg,var(--cy),#7fb0ff);font-family:inherit;width:100%}
.btn.ghost{background:transparent;color:var(--mu);border:2px solid rgba(255,255,255,.18);margin-top:12px}
.btn.red{background:rgba(255,90,95,.18);color:#ff8a8e;border:2px solid #ff5a5f;margin-top:12px}
.sp{flex:1;min-height:16px}
.dots{display:flex;gap:8px;margin-bottom:6px}.dot{height:6px;flex:1;border-radius:3px;background:rgba(255,255,255,.15)}.dot.on{background:var(--cy)}
.robot{animation:bob 3s ease-in-out infinite}@keyframes bob{50%{transform:translateY(-8px)}}
.eye{animation:blink 5s infinite;transform-origin:center;transform-box:fill-box}
@keyframes blink{0%,94%,100%{transform:scaleY(1)}97%{transform:scaleY(.1)}}
.hdr{display:flex;align-items:center;gap:12px;padding:calc(env(safe-area-inset-top) + 10px) 16px 10px;background:rgba(5,10,34,.75);border-bottom:1px solid rgba(255,255,255,.08)}
.hdr .t{flex:1}.hdr .t b{font-size:19px}.hdr .t span{display:block;font-size:13px;color:var(--mu)}
.hdr .t span:before{content:'';display:inline-block;width:8px;height:8px;border-radius:50%;background:#7dffb3;margin-right:6px}
.gear{width:44px;height:44px;border-radius:50%;border:0;background:rgba(255,255,255,.08);color:#fff;font-size:22px}
#msgs{flex:1;overflow-y:auto;padding:12px 16px}
.m{max-width:86%;padding:12px 16px;border-radius:22px;margin:8px 0;line-height:1.42;font-size:17px;word-wrap:break-word;animation:fin .25s ease both}
.m p{margin:0 0 6px}.m p:last-child{margin:0}.m ul,.m ol{margin:4px 0 6px;padding-left:22px}.m code{background:rgba(0,0,0,.3);padding:1px 6px;border-radius:6px}
.m.u{margin-left:auto;background:rgba(255,255,255,.15);border-bottom-right-radius:6px}
.m.a{background:linear-gradient(135deg,#6b57e8,#4d8dff);border-bottom-left-radius:6px}
.m.err{background:rgba(255,90,95,.2);border:1px solid #ff5a5f}
.typing span{display:inline-block;width:8px;height:8px;border-radius:50%;background:#fff;margin:0 2px;animation:tp 1s infinite}
.typing span:nth-child(2){animation-delay:.15s}.typing span:nth-child(3){animation-delay:.3s}
@keyframes tp{0%,60%,100%{transform:translateY(0);opacity:.5}30%{transform:translateY(-6px);opacity:1}}
#quick{display:flex;gap:8px;overflow-x:auto;padding:6px 16px 8px;scrollbar-width:none}
#quick .chip{white-space:nowrap;font-size:15px;padding:9px 14px}
.bar{display:flex;gap:10px;align-items:flex-end;padding:8px 12px calc(env(safe-area-inset-bottom) + 12px);background:rgba(5,10,34,.85)}
.bar textarea{flex:1;max-height:120px;border-radius:24px;padding:13px 18px;resize:none;font-size:17px}
.send{width:52px;height:52px;border-radius:50%;border:0;background:linear-gradient(135deg,var(--cy),#7fb0ff);color:#07102e;font-size:24px;font-weight:900}
.send:disabled{opacity:.4}
.banner{margin:8px 16px;padding:12px 16px;border-radius:16px;background:rgba(255,207,90,.15);border:1px solid #ffcf5a;font-size:15px}
a{color:var(--cy)}
</style>
</head>
<body>
<div id="app"></div>
<script src="config.js"></script>
<script>
var LS = {
  get: function (k, d) { try { var v = localStorage.getItem(k); return v ? JSON.parse(v) : d; } catch (e) { return d; } },
  set: function (k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} }
};
var CFG = window.LUMEN_CONFIG || {};
var profile = LS.get('lumen_profile', null);
var hist = LS.get('lumen_hist', []);
var settings = LS.get('lumen_settings', {apiKey: '', model: ''});
var view = 'welcome';
var busy = false;
var STEPS = ['welcome', 'name', 'job', 'needs', 'style', 'key'];
var NEEDS = ['Kun rejasi', 'Sog‘liq', 'Moliya', 'O‘qish', 'Ish unumdorligi', 'Ijod', 'Sayohat', 'Oila'];
var JOBS = ['Talaba', 'Dasturchi', 'Tadbirkor', 'O‘qituvchi', 'Shifokor', 'Dizayner', 'Haydovchi', 'Boshqa'];
var TONES = ['Do‘stona', 'Rasmiy', 'Qisqa va aniq', 'Motivatsion'];
var NEED_PROMPT = {
  'Kun rejasi': 'Bugungi kunim uchun aniq reja tuz.',
  'Sog‘liq': 'Sog‘lig‘im uchun bugun nimalarga e’tibor berishim kerak? Qisqa maslahat ber.',
  'Moliya': 'Xarajatlarimni nazorat qilish uchun oddiy reja taklif qil.',
  'O‘qish': 'Bugun nima o‘rganishim mumkin? Qisqa o‘quv reja ber.',
  'Ish unumdorligi': 'Ish unumdorligimni oshirish uchun 3 ta amaliy maslahat ber.',
  'Ijod': 'Menga ijodiy g‘oya ber va boshlash uchun qadamlarni ayt.',
  'Sayohat': 'Yaqin hafta oxiri uchun sayohat g‘oyasi ber.',
  'Oila': 'Oilam bilan vaqt o‘tkazish uchun bugun nima qilsam bo‘ladi?'
};
var draft = {name: '', job: '', needs: [], extra: '', tone: TONES[0], goal: '', wake: '07:00'};
var app = document.getElementById('app');
function $(id) { return document.getElementById(id); }
function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
function getKey() { if (settings.apiKey) { return settings.apiKey; } var k = CFG.apiKey; if (k && k.indexOf('__') !== 0) { return k; } return ''; }
function getModel() { return settings.model || CFG.model || 'gemini-2.5-flash'; }
function saveHist() { LS.set('lumen_hist', hist.slice(-60)); }

function robot(sz) {
  return '<svg class="robot" width="' + sz + '" height="' + Math.round(sz * 1.1) + '" viewBox="0 0 400 440">' +
    '<defs><linearGradient id="rb" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#c9d4ff"/></linearGradient></defs>' +
    '<line x1="125" y1="84" x2="95" y2="24" stroke="#b8c4ff" stroke-width="8" stroke-linecap="round"/><circle cx="95" cy="24" r="13" fill="#2de2ff"/>' +
    '<line x1="275" y1="84" x2="305" y2="24" stroke="#b8c4ff" stroke-width="8" stroke-linecap="round"/><circle cx="305" cy="24" r="13" fill="#2de2ff"/>' +
    '<rect x="135" y="312" width="130" height="100" rx="44" fill="url(#rb)"/><circle cx="200" cy="360" r="12" fill="#2de2ff"/>' +
    '<circle cx="52" cy="205" r="30" fill="#e9eeff" stroke="#b3c0ff" stroke-width="5"/><circle cx="348" cy="205" r="30" fill="#e9eeff" stroke="#b3c0ff" stroke-width="5"/>' +
    '<rect x="60" y="70" width="280" height="250" rx="110" fill="url(#rb)"/>' +
    '<rect x="88" y="132" width="224" height="150" rx="62" fill="#0a1230" stroke="#27348a" stroke-width="5"/>' +
    '<path d="M92 118 L118 56 Q200 38 282 56 L308 118 Q200 134 92 118 Z" fill="#14142e"/>' +
    '<path d="M130 87 l9 9 l-9 9 l-9 -9z M165 87 l9 9 l-9 9 l-9 -9z M200 87 l9 9 l-9 9 l-9 -9z M235 87 l9 9 l-9 9 l-9 -9z M270 87 l9 9 l-9 9 l-9 -9z" fill="#fff"/>' +
    '<rect class="eye" x="130" y="172" width="44" height="58" rx="20" fill="#9ff3ff"/><rect class="eye" x="226" y="172" width="44" height="58" rx="20" fill="#9ff3ff"/>' +
    '<path d="M168 252 Q200 270 232 252" fill="none" stroke="#2de2ff" stroke-width="6" stroke-linecap="round"/></svg>';
}

function dots(i) {
  var s = '<div class="dots">';
  for (var k = 1; k < STEPS.length; k++) { s += '<div class="dot' + (k <= i ? ' on' : '') + '"></div>'; }
  return s + '</div>';
}
function show(v) { view = v; render(); }
function nextStep() {
  var i = STEPS.indexOf(view) + 1;
  if (STEPS[i] === 'key' && getKey()) { i++; }
  if (i >= STEPS.length) { finish(); } else { show(STEPS[i]); }
}
function prevStep() { var i = STEPS.indexOf(view) - 1; if (i >= 0) { show(STEPS[i]); } }
function bad(id) { var e = $(id); if (e) { e.classList.remove('bad'); void e.offsetWidth; e.classList.add('bad'); e.focus(); } }
function backRow() { return '<button class="btn ghost" onclick="prevStep()">Orqaga</button>'; }

function render() {
  if (view === 'chat') { buildChat(); return; }
  if (view === 'settings') { buildSettings(); return; }
  var i = STEPS.indexOf(view);
  var h = '';
  if (view === 'welcome') {
    h = '<div class="scr" style="align-items:center;text-align:center;justify-content:center">' + robot(210) +
      '<h1>Salom! Men <span style="color:var(--cy)">Lumen</span></h1>' +
      '<p class="sub">Shaxsiy AI yordamchingiz. Sizni yaqinroq tanishim uchun bir necha savol beraman.</p>' +
      '<div class="sp"></div><button class="btn" onclick="nextStep()">Boshlaymiz</button></div>';
  } else if (view === 'name') {
    h = '<div class="scr">' + dots(i) + '<h1>Ismingiz nima?</h1><p class="sub">Sizga ismingiz bilan murojaat qilaman.</p>' +
      '<input id="f_name" value="' + esc(draft.name) + '" placeholder="Masalan: Aziz" autocomplete="off">' +
      '<div class="sp"></div><button class="btn" onclick="saveName()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'job') {
    var jc = '';
    JOBS.forEach(function (j, k) { jc += '<button class="chip" onclick="pickJob(' + k + ')">' + j + '</button>'; });
    h = '<div class="scr">' + dots(i) + '<h1>Qanday ish bilan shug‘ullanasiz?</h1><p class="sub">Kasbingiz yoki mashg‘ulotingiz — javoblarni sizga moslash uchun.</p>' +
      '<input id="f_job" value="' + esc(draft.job) + '" placeholder="Masalan: dasturchi, talaba..." autocomplete="off">' +
      '<div class="chips">' + jc + '</div><div class="sp"></div><button class="btn" onclick="saveJob()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'needs') {
    var nc = '';
    NEEDS.forEach(function (n, k) { nc += '<button class="chip' + (draft.needs.indexOf(n) >= 0 ? ' on' : '') + '" onclick="toggleNeed(' + k + ')">' + n + '</button>'; });
    h = '<div class="scr">' + dots(i) + '<h1>Sizga nima kerak?</h1><p class="sub">Bir nechtasini tanlashingiz mumkin.</p>' +
      '<div class="chips">' + nc + '</div>' +
      '<label class="l">YANA NIMA KERAK? (IXTIYORIY)</label><textarea id="f_extra" rows="3" placeholder="Masalan: ingliz tilini o‘rganmoqchiman">' + esc(draft.extra) + '</textarea>' +
      '<div class="sp"></div><button class="btn" onclick="saveNeeds()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'style') {
    var tc = '';
    TONES.forEach(function (t, k) { tc += '<button class="chip' + (draft.tone === t ? ' on' : '') + '" onclick="pickTone(' + k + ')">' + t + '</button>'; });
    h = '<div class="scr">' + dots(i) + '<h1>Qanday gaplashay?</h1><p class="sub">Uslubingizni tanlang va bir-ikki narsani aytib qo‘ying.</p>' +
      '<div class="chips">' + tc + '</div>' +
      '<label class="l">ASOSIY MAQSADINGIZ (IXTIYORIY)</label><input id="f_goal" value="' + esc(draft.goal) + '" placeholder="Masalan: har kuni kitob o‘qish" autocomplete="off">' +
      '<label class="l">ERTALAB SOAT NECHADA TURASIZ?</label><input id="f_wake" type="time" value="' + esc(draft.wake) + '">' +
      '<div class="sp"></div><button class="btn" onclick="saveStyle()">Davom etish</button>' + backRow() + '</div>';
  } else if (view === 'key') {
    h = '<div class="scr">' + dots(i) + '<h1>Google AI kaliti</h1><p class="sub">Men Google Gemini bilan ishlayman. Bepul kalitni <a href="https://aistudio.google.com/app/apikey">aistudio.google.com/app/apikey</a> sahifasida olishingiz mumkin.</p>' +
      '<input id="f_key" type="password" placeholder="AIza..." autocomplete="off">' +
      '<div class="sp"></div><button class="btn" onclick="saveKey()">Saqlash va boshlash</button>' +
      '<button class="btn ghost" onclick="finish()">Keyinroq</button>' + backRow() + '</div>';
  }
  app.innerHTML = h;
}
function saveName() { var v = $('f_name').value.trim(); if (!v) { bad('f_name'); return; } draft.name = v; nextStep(); }
function pickJob(k) { if (JOBS[k] === 'Boshqa') { $('f_job').value = ''; $('f_job').focus(); return; } $('f_job').value = JOBS[k]; }
function saveJob() { var v = $('f_job').value.trim(); if (!v) { bad('f_job'); return; } draft.job = v; nextStep(); }
function toggleNeed(k) { draft.extra = $('f_extra').value; var n = NEEDS[k]; var i = draft.needs.indexOf(n); if (i >= 0) { draft.needs.splice(i, 1); } else { draft.needs.push(n); } render(); }
function saveNeeds() { draft.extra = $('f_extra').value.trim(); if (!draft.needs.length && !draft.extra) { draft.needs = ['Kun rejasi']; } nextStep(); }
function pickTone(k) { draft.goal = $('f_goal').value; draft.wake = $('f_wake').value || '07:00'; draft.tone = TONES[k]; render(); }
function saveStyle() { draft.goal = $('f_goal').value.trim(); draft.wake = $('f_wake').value || '07:00'; nextStep(); }
function saveKey() { var v = $('f_key').value.trim(); if (!v) { bad('f_key'); return; } settings.apiKey = v; LS.set('lumen_settings', settings); finish(); }

function finish() {
  profile = JSON.parse(JSON.stringify(draft));
  LS.set('lumen_profile', profile);
  var g = 'Salom, ' + profile.name + '! 👋 Men Lumenman.\n\nSiz ' + profile.job.toLowerCase() + ' ekansiz. Men sizga ' + (profile.needs.length ? profile.needs.join(', ').toLowerCase() : 'turli masalalar') + ' bo‘yicha yordam beraman.';
  if (profile.goal) { g += '\n\nMaqsadingiz: ' + profile.goal + ' — buni birga amalga oshiramiz.'; }
  g += '\n\nBugun nimadan boshlaymiz?';
  hist = [{role: 'model', text: g}];
  saveHist();
  view = 'chat';
  buildChat();
}

function inline(s) { return esc(s).replace(/\*\*(.+?)\*\*/g, '<b>$1</b>').replace(/`([^`]+)`/g, '<code>$1</code>'); }
function md(t) {
  var lines = String(t).split('\n'); var out = ''; var list = '';
  function close() { if (list) { out += '</' + list + '>'; list = ''; } }
  lines.forEach(function (ln) {
    var m1 = ln.match(/^\s*[-*•]\s+(.*)$/); var m2 = ln.match(/^\s*\d+[.)]\s+(.*)$/); var hm = ln.match(/^#{1,3}\s+(.*)$/);
    if (m1) { if (list !== 'ul') { close(); out += '<ul>'; list = 'ul'; } out += '<li>' + inline(m1[1]) + '</li>'; }
    else if (m2) { if (list !== 'ol') { close(); out += '<ol>'; list = 'ol'; } out += '<li>' + inline(m2[1]) + '</li>'; }
    else { close(); if (hm) { out += '<p><b>' + inline(hm[1]) + '</b></p>'; } else if (ln.trim() !== '') { out += '<p>' + inline(ln) + '</p>'; } }
  });
  close();
  return out;
}

function buildChat() {
  var q = '';
  q += '<button class="chip" onclick="quick(-1)">☀️ Ertalabki briefing</button>';
  (profile.needs || []).slice(0, 4).forEach(function (n, k) { q += '<button class="chip" onclick="quick(' + k + ')">' + n + '</button>'; });
  app.innerHTML = '<div class="hdr">' + robot(44) + '<div class="t"><b>Agent Lumen</b><span>onlayn · Gemini</span></div><button class="gear" onclick="openSettings()">⚙</button></div>' +
    '<div id="banner"></div><div id="msgs"></div><div id="quick">' + q + '</div>' +
    '<div class="bar"><textarea id="inp" rows="1" placeholder="Xabar yozing..."></textarea><button class="send" id="sendBtn" onclick="doSend()">➤</button></div>';
  var inp = $('inp');
  inp.addEventListener('keydown', function (e) { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); doSend(); } });
  inp.addEventListener('input', function () { inp.style.height = 'auto'; inp.style.height = Math.min(120, inp.scrollHeight) + 'px'; });
  updateMsgs();
}
function updateMsgs() {
  var b = $('banner'); if (b) { b.innerHTML = getKey() ? '' : '<div class="banner" onclick="openSettings()">⚠ Google API kaliti kiritilmagan. Bu yerni bosib kiriting.</div>'; }
  var h = '';
  hist.forEach(function (m) { h += '<div class="m ' + (m.role === 'user' ? 'u' : (m.err ? 'a err' : 'a')) + '">' + md(m.text) + '</div>'; });
  if (busy) { h += '<div class="m a typing"><span></span><span></span><span></span></div>'; }
  var box = $('msgs'); if (!box) { return; }
  box.innerHTML = h; box.scrollTop = box.scrollHeight;
  var sb = $('sendBtn'); if (sb) { sb.disabled = busy; }
}
function quick(k) {
  if (k < 0) { send('Menga bugungi kun uchun qisqa ertalabki briefing tayyorla: reja, 2 ta maslahat va bitta motivatsion gap.'); return; }
  send(NEED_PROMPT[profile.needs[k]] || profile.needs[k]);
}
function doSend() { var inp = $('inp'); var t = inp.value; inp.value = ''; inp.style.height = 'auto'; send(t); }

function sysPrompt() {
  var p = profile; var d = new Date();
  var days = ['yakshanba', 'dushanba', 'seshanba', 'chorshanba', 'payshanba', 'juma', 'shanba'];
  function z(n) { return n < 10 ? '0' + n : '' + n; }
  var now = d.getFullYear() + '-' + z(d.getMonth() + 1) + '-' + z(d.getDate()) + ' ' + z(d.getHours()) + ':' + z(d.getMinutes()) + ' (' + days[d.getDay()] + ')';
  return 'Sen "Agent Lumen" — o‘zbek tilida gaplashadigan shaxsiy AI yordamchisan. ' +
    'Foydalanuvchi ismi: ' + p.name + '. Kasbi/mashg‘uloti: ' + p.job + '. ' +
    'U quyidagi mavzularda yordam so‘ragan: ' + (p.needs.length ? p.needs.join(', ') : 'umumiy') + '. ' +
    (p.extra ? 'Qo‘shimcha ehtiyoji: ' + p.extra + '. ' : '') +
    (p.goal ? 'Asosiy maqsadi: ' + p.goal + '. ' : '') +
    'Ertalab soat ' + p.wake + ' da turadi. Gaplashish uslubi: ' + p.tone + '. ' +
    'Hozirgi sana va vaqt: ' + now + '. ' +
    'Qoidalar: foydalanuvchi boshqa tilda yozmasa, o‘zbek tilida (lotin yozuvida) javob ber. Javoblar qisqa, aniq va amaliy bo‘lsin; kerak bo‘lsa qisqa ro‘yxatlardan foydalan. Foydalanuvchiga ismi bilan, iliq murojaat qil. ' +
    'Sog‘liq, moliya va huquq masalalarida umumiy ma’lumot ber, tibbiy yoki moliyaviy maslahat o‘rnini bosmasligini qisqa eslat, jiddiy holatda mutaxassisga murojaat qilishni tavsiya et. Bilmagan narsangni to‘qima.';
}
function askGemini() {
  var url = 'https://generativelanguage.googleapis.com/v1beta/models/' + encodeURIComponent(getModel()) + ':generateContent?key=' + encodeURIComponent(getKey());
  var contents = hist.filter(function (m) { return !m.err; }).slice(-24).map(function (m) { return {role: m.role, parts: [{text: m.text}]}; });
  while (contents.length && contents[0].role !== 'user') { contents.shift(); }
  var body = {systemInstruction: {parts: [{text: sysPrompt()}]}, contents: contents, generationConfig: {temperature: 0.8, maxOutputTokens: 1200}};
  return fetch(url, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(body)}).then(function (r) {
    return r.json().catch(function () { return {}; }).then(function (data) {
      if (!r.ok) { var e = new Error((data.error && data.error.message) || ('HTTP ' + r.status)); e.status = r.status; throw e; }
      var c = data.candidates && data.candidates[0]; var parts = c && c.content && c.content.parts;
      var t = parts ? parts.map(function (p) { return p.text || ''; }).join('') : '';
      if (!t) { throw new Error(data.promptFeedback && data.promptFeedback.blockReason ? 'blocked' : 'empty'); }
      return t;
    });
  });
}
function errMsg(e) {
  var m = String(e && e.message || '');
  if (e && e.name === 'TypeError') { return 'Internet bilan aloqa yo‘q. Ulanishni tekshirib, qayta urinib ko‘ring.'; }
  if (e && e.status === 400 && /API key/i.test(m)) { return 'API kaliti noto‘g‘ri. Sozlamalardan kalitni tekshiring.'; }
  if (e && e.status === 403) { return 'Kalitga ruxsat yo‘q. Kalit to‘g‘riligini va Gemini API yoqilganini tekshiring.'; }
  if (e && e.status === 404) { return 'Model topilmadi (' + getModel() + '). Sozlamalarda model nomini o‘zgartiring.'; }
  if (e && e.status === 429) { return 'So‘rovlar limiti tugadi. Birozdan keyin qayta urinib ko‘ring.'; }
  if (m === 'blocked') { return 'Bu so‘rovga javob berolmayman. Boshqacha so‘rab ko‘ring.'; }
  if (m === 'empty') { return 'Javob bo‘sh keldi. Qayta urinib ko‘ring.'; }
  return 'Xatolik: ' + m;
}
function send(text) {
  text = (text || '').trim();
  if (!text || busy) { return; }
  hist.push({role: 'user', text: text});
  if (!getKey()) { hist.push({role: 'model', text: 'Google API kaliti kiritilmagan. Sozlamalar (⚙) bo‘limidan kalitni kiriting.', err: true}); saveHist(); updateMsgs(); return; }
  busy = true; saveHist(); updateMsgs();
  askGemini().then(function (t) { hist.push({role: 'model', text: t}); }, function (e) { hist.push({role: 'model', text: errMsg(e), err: true}); }).then(function () { busy = false; saveHist(); updateMsgs(); });
}

function openSettings() { view = 'settings'; buildSettings(); }
function buildSettings() {
  var tc = '';
  TONES.forEach(function (t, k) { tc += '<button class="chip' + (profile.tone === t ? ' on' : '') + '" onclick="setTone(' + k + ')">' + t + '</button>'; });
  app.innerHTML = '<div class="scr"><h1>Sozlamalar</h1>' +
    '<label class="l">ISM</label><input id="s_name" value="' + esc(profile.name) + '">' +
    '<label class="l">KASB</label><input id="s_job" value="' + esc(profile.job) + '">' +
    '<label class="l">GAPLASHISH USLUBI</label><div class="chips">' + tc + '</div>' +
    '<label class="l">GOOGLE (GEMINI) API KALITI</label><input id="s_key" type="password" value="' + esc(settings.apiKey) + '" placeholder="' + (CFG.apiKey && CFG.apiKey.indexOf('__') !== 0 ? 'Ilova ichidagi kalit ishlatilmoqda' : 'AIza...') + '">' +
    '<label class="l">MODEL</label><input id="s_model" value="' + esc(settings.model) + '" placeholder="' + esc(CFG.model || 'gemini-2.5-flash') + '">' +
    '<div class="sp"></div><button class="btn" onclick="saveSettings()">Saqlash</button>' +
    '<button class="btn ghost" onclick="clearChat()">Suhbatni tozalash</button>' +
    '<button class="btn red" onclick="resetAll()">Profilni qayta to‘ldirish</button>' +
    '<button class="btn ghost" onclick="closeSettings()">Orqaga</button></div>';
}
function setTone(k) { profile.tone = TONES[k]; readSettings(); LS.set('lumen_profile', profile); buildSettings(); }
function readSettings() {
  profile.name = $('s_name').value.trim() || profile.name; profile.job = $('s_job').value.trim() || profile.job;
  settings.apiKey = $('s_key').value.trim(); settings.model = $('s_model').value.trim();
}
function saveSettings() { readSettings(); LS.set('lumen_profile', profile); LS.set('lumen_settings', settings); closeSettings(); }
function closeSettings() { view = 'chat'; buildChat(); }
function clearChat() { hist = [{role: 'model', text: 'Suhbat tozalandi. Yangidan boshlaymiz, ' + profile.name + '! Nima qilamiz?'}]; saveHist(); closeSettings(); }
function resetAll() { if (!confirm('Profil va suhbat o‘chiriladi. Davom etamizmi?')) { return; } LS.set('lumen_profile', null); LS.set('lumen_hist', []); profile = null; hist = []; draft = {name: '', job: '', needs: [], extra: '', tone: TONES[0], goal: '', wake: '07:00'}; show('welcome'); }

window.lumenBack = function () {
  if (view === 'settings') { closeSettings(); return true; }
  var i = STEPS.indexOf(view);
  if (i > 0) { prevStep(); return true; }
  return false;
};
if (profile) { view = 'chat'; buildChat(); } else { render(); }
</script>
</body>
</html>
LUMEN_EOF
echo "Loyiha fayllari yaratildi"
