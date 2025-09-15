#!/bin/bash
sourcekitten doc --spm --module-name SimpleLoggerUI > SimpleLoggerUI.json
sourcekitten doc --spm --module-name SimpleLogger > SimpleLogger.json
jazzy
