-- Im here to add some bytes

SektenLR = LibStub("AceAddon-3.0"):NewAddon("Sekten Loot Recorder", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0" )
SLR = {}

slr_version = "0.1"

sekten_version_data = {}

function SektenLR:OnInitialize()
  
end

function SektenLR:OnEnabled()
  self:Print("Loaded ("..slr_version..")")
end