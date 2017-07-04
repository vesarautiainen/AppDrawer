APP_ID=com.ubuntu.developer.bpierre.example

GRID_UNIT_PX=12
IMPORT_PATH=../..
APP_ENTRY=MainWin.qml

QMLSCENE_BIN=GRID_UNIT_PX=$(GRID_UNIT_PX) QML2_IMPORT_PATH=$(IMPORT_PATH) qmlscene

all: run

run:
	$(QMLSCENE_BIN) $(APP_ENTRY)

liverun: kill
	$(QMLSCENE_BIN) $(APP_ENTRY) &

slowliverun: kill
	$(QMLSCENE_BIN) $(APP_ENTRY) --slow-animations &

kill:
	kill -9 $(shell ps aux | grep qmlscene | grep -v grep | awk '{print $$2}')
