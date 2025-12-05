function deleteObj(mws,obj)
%DELETEOBJ 删除形状

sCommend = sprintf('Solid.Delete "%s"',obj);
invoke(mws,'AddToHistory',sprintf('delete shape:%s',obj),sCommend);

end

