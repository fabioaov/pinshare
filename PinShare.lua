local function OnEvent(self, event, ...)
	if event == "USER_WAYPOINT_UPDATED" then
		C_Timer.After(.3, function()
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
		end)

		local hyperlink = C_Map.GetUserWaypointHyperlink()

		if hyperlink then
			local prefix = "PinShare"
			local chat_type = (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or "PARTY"

			C_ChatInfo.SendAddonMessage(prefix, hyperlink, chat_type)
			C_ChatInfo.RegisterAddonMessagePrefix(prefix)
		end
	elseif event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...
		local playerName = UnitName("player") .. "-" .. GetRealmName()

		if prefix == "PinShare" and (channel == "INSTANCE_CHAT" or channel == "RAID" or channel == "PARTY") and not UnitIsUnit(sender, playerName) then
			local newPin = C_Map.GetUserWaypointFromHyperlink(message)
			local curPin = C_Map.GetUserWaypoint()

			if (curPin ~= nil and string.sub(curPin.position.x, 1, 4) ~= string.sub(newPin.position.x, 1, 4) and string.sub(curPin.position.y, 1, 4) ~= string.sub(newPin.position.y, 1, 4)) then
				C_Map.SetUserWaypoint(newPin)

				C_Timer.After(.3, function()
					C_SuperTrack.SetSuperTrackedUserWaypoint(true)
				end)
			end
		end
	end
end

local PinShare = CreateFrame("frame")

PinShare:RegisterEvent("USER_WAYPOINT_UPDATED")
PinShare:RegisterEvent("CHAT_MSG_ADDON")
PinShare:SetScript("OnEvent", OnEvent)