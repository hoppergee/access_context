AccessContext.config do
  roles do
    grant :admin, ['default', 'order_read', 'admin_default']
    grant :support, 'default'
    grant :support, 'order_read'
  end
  permissions do
    grant 'default' do
      controller :home, [:show]
      controller :dashboard, [:show]
      service :visit, :call
      job :welcome, :perform
    end
    grant 'admin_default' do
      controller 'admin/dashboard', [:show]
      context :controller, "admin/orders", :show
    end
    grant 'order_read' do
      controller :orders, [:show]
      view 'admin/orders', ["order_edit_button"]
    end
  end
end