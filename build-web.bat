@echo off
flutter build web --release --base-href="/silence/" & scp -Cr build\web chris@backstreets.site:silence