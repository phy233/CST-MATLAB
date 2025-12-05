function deleteComponent(mws,obj)
%DELETECOMPONENT 删除整个形状的组件文件夹
%   
sCommend = sprintf('Component.Delete "%s"',obj);
invoke(mws,'AddToHistory',sprintf('delete component:%s',obj),sCommend);
end

