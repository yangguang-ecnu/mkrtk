function handles = initTools(handles,modestr)
% Configure toolbars & other tools for use in different imaging modes.
%
% MODESTR One of either '2d' or '3d' depending on if the calling program.


load icons.mat % Creates structure variable: icons
hf = handles.figure1;

% Firstly add the standard matlab figure toolbar:
set(hf,'Toolbar','figure')

% Then kill the docking arrow, as we don't want to see it:
set(hf,'DockControls','off')

% Now modify the standard toolbar.  The following two lines show us
% what the tags for all the tools are: 
%
%   hToolbar = findall(gcf,'tag','FigureToolBar');
%   get(findall(hToolbar),'tag')
%
% Which gives:
%     'FigureToolBar'
%     'Plottools.PlottoolsOn'
%     'Plottools.PlottoolsOff'
%     'Annotation.InsertLegend'
%     'Annotation.InsertColorbar'
%     'DataManager.Linking'
%     'Exploration.Brushing'
%     'Exploration.DataCursor'
%     'Exploration.Rotate'
%     'Exploration.Pan'
%     'Exploration.ZoomOut'
%     'Exploration.ZoomIn'
%     'Standard.EditPlot'
%     'Standard.PrintFigure'
%     'Standard.SaveFigure'
%     'Standard.FileOpen'
%     'Standard.NewFigure'

set(findall(hf,'tag','Standard.EditPlot'),'Visible','off');

% Flag these tools for removal:
removeTags = {...
    'Plottools.PlottoolsOn',...
    'Plottools.PlottoolsOff',...
    'Annotation.InsertColorbar',...
    'DataManager.Linking',...
    'Standard.PrintFigure',...
    'Standard.SaveFigure',...
    'Standard.FileOpen',...
    'Standard.NewFigure',...
    };

% Get the parent toolbar:
handles.Toolbar = findall(hf,'Tag','FigureToolBar');%get(hd(end),'Parent'); 

% Remove separator:
set(findall(hf,'Tag','Exploration.ZoomIn'),'Separator','off')

% Function to create a nice separator using an inactive button:
addsep = @()uitoggletool(handles.Toolbar,...
    'Tag','CustomSeparator',...
    'Enable','off',...
    'Visible','off',...
    'CData',repmat(ones(20,1)*.1,[1,1,3]));

% Get calling function:
ds = dbstack(1);
[~,calling_mfile,~] = fileparts(ds(1).file);

% Create a convenient callback generator using an anonymous fcn:
%   (Makes a callback in the standard format used by GUIDE)
cbk = @(cstr)eval(['@(hObject,eventdata)' calling_mfile ...
    '(''' cstr ''',hObject,eventdata,guidata(hObject))']);

% UIPUSHTOOL Note:  When building uipushtools, we also take advantage of
%       the "OnCallback" and "OffCallback" so that we can toggle the tools
%       from elsewhere in the program and the callback will run.

switch lower( modestr )
    
    case '2d'
        
        %---- 2D also remove these:
        removeTags = [removeTags,...
            {'Annotation.InsertLegend',...
            'Exploration.Brushing',...
            'Exploration.DataCursor',...
            'Exploration.Rotate'}];
        
        %---- 2D create tools:
        addsep();
        handles.ResetBcTool = uitoggletool(handles.Toolbar,...
            'Tag','ResetBcTool',...
            'CData',icons.resetbc,...
            'TooltipString',    'Reset Brightness & Contrast',...
            'OnCallback',       cbk('ResetBcTool_ClickedCallback'),...
            'OffCallback',      cbk('ResetBcTool_ClickedCallback'));
        
        handles.AutoBcTool = uitoggletool(handles.Toolbar,...
            'Tag','AutoBcTool',...
            'CData',icons.autobc,...
            'TooltipString',    'Automatic Brightness & Contrast',...
            'OnCallback',       cbk('AutoBcTool_ClickedCallback'),...
            'OffCallback',      cbk('AutoBcTool_ClickedCallback'));
        
        handles.AdjustBcTool = uitoggletool(handles.Toolbar,...
            'Tag','AdjustBcTool',...
            'CData',icons.adjustbc,...
            'TooltipString',    'Adjust Brightness & Contrast interactively with mouse',...
            'OnCallback',       cbk('AdjustBcTool_ClickedCallback'),...
            'OffCallback',      cbk('AdjustBcTool_ClickedCallback'));
        
        handles.TraceTool = uitoggletool(handles.Toolbar,...
            'Tag','TraceTool',...
            'CData',icons.roipen,...
            'TooltipString',    'ROI tracing tool',...
            'OnCallback',       cbk('TraceTool_ClickedCallback'),...
            'OffCallback',      cbk('TraceTool_ClickedCallback'));
        
        handles.DeleteTraceTool = uipushtool(handles.Toolbar,...
            'Tag','DeleteTraceTool',...
            'CData',icons.trash,...
            'TooltipString',    'Delete all ROIs',...
            'ClickedCallback',  cbk('DeleteTraceTool_ClickedCallback'));
        
        handles.toolset = [...
            handles.ResetBcTool,...
            handles.AutoBcTool,...
            handles.AdjustBcTool,...
            handles.TraceTool,...
            handles.DeleteTraceTool...
            ];
        
    case '3d'
        
        %---- 3D also remove these:
        %removeTags = {removeTags{:}, }
        
        %---- 3D create tools:
        addsep();
        %{
        handles.ICPCalculateTool = uipushtool(handles.Toolbar,...
            'Tag','ICPCalculateTool',...
            'CData',icons.process,...
            'TooltipString',    'Calculate ICP Registration',...
            'ClickedCallback',  cbk('ICPCalculateTool_Callback'));
        %}
        handles.ShowStaticTool = uitoggletool(handles.Toolbar,...
            'Separator','off',...
            'Tag','ShowStaticTool',...
            'CData',icons.staticCloud,...
            'TooltipString',    'Show static clouds',...
            'OnCallback',       cbk('CloudVisibility_Callback'),...
            'OffCallback',      cbk('CloudVisibility_Callback'));
        
        handles.ShowDynamicTool = uitoggletool(handles.Toolbar,...
            'Tag','ShowDynamicTool',...
            'CData',icons.dynamicCloud,...
            'TooltipString',    'Show dynamic clouds',...
            'OnCallback',       cbk('CloudVisibility_Callback'),...
            'OffCallback',      cbk('CloudVisibility_Callback'));
        %{
        handles.HelicalAxisTool = uipushtool(handles.Toolbar,...
            'Tag','ShowDynamicTool',...
            'CData',icons.helical,...
            'TooltipString',    'Calculate Helical Axis',...
            'ClickedCallback',  cbk('HelicalAxis_Callback'));
        %}
        
        handles.ShowAxesTool = uitoggletool(handles.Toolbar,...
            'Tag','ShowAxesTool',...
            'CData',icons.coord_system,...
            'TooltipString',   'Show coordinate systems',...
            'OnCallback',      cbk('ShowAxesTool_Callback'),...
            'OffCallback',     cbk('ShowAxesTool_Callback'));
        
        handles.TrashMotionTool = uipushtool(handles.Toolbar,...
            'Separator','off',...
            'Tag','TrashMotionTool',...
            'CData',icons.trash,...
            'TooltipString',    'Clear motion computations',...
            'ClickedCallback',  cbk('ClearAnalysis_Callback'));
        
        handles.toolset = [...          % List all 3D tools
            ... %handles.ICPCalculateTool,...
            handles.ShowStaticTool,...
            handles.ShowDynamicTool,...
            ... %handles.HelicalAxisTool,...
            handles.TrashMotionTool];
        
    case 'solver'
        % Now use our SelectiveBrush class to simply hide the databrushing tool:
        SelectiveBrush.HideTool(handles.figure1);
        
        % Now set icon for reset button:
        load icons;
        set(handles.ClearAllButton,'CData',icons.reset)
        
end %switch

% Remove all tools flagged for deletion:
for j = numel(removeTags) : -1 : 1
    hd(j) = findall(hf,'Tag',removeTags{j});
end
delete(hd);