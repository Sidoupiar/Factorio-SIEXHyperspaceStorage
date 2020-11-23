-- ------------------------------------------------------------------------------------------------
-- -------- 修改阵营数据 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- 创建全局引用
SIGlobal.CreateOnMigrations()

for forceIndex , forceData in pairs( containerData ) do
	for i , v in pairs( forceData.i or {} ) do
		if not v[4] then v[4] = NewEntityIndex() end
	end
	for i , v in pairs( forceData.o or {} ) do
		if not v[4] then v[4] = NewEntityIndex() end
	end
end

for playerIndex , settings in pairs( teleporterView ) do
	if settings.view then
		settings.view.destroy()
		settings.view = nil
		settings.list = nil
		settings.selectType = nil
		settings.selectIndex = nil
		settings.textField = nil
		-- 重新打开窗口
		SIEXHSTeleporterView.OpenView( playerIndex )
	end
end