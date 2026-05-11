$(document).ready(function() {
    console.log('FoodSupplier.js 加载完成');
    UpdateOrders();
    var update_orders = setInterval(UpdateOrders, 10 * 1000);
});

function UpdateOrders() {
    console.log('正在更新订单...');
    $("#orders").empty();
    $.post("/manage/serving_order_item_list", function(data) {
        console.log('收到订单数据:', data);
        try {
            var orders = JSON.parse(data);
            console.log('解析后的订单数据:', orders);

            // 使用新的渲染函数
            if (typeof window.renderOrderCards === 'function') {
                console.log('使用新的渲染函数 renderOrderCards');
                window.renderOrderCards(orders);
            } else {
                console.log('renderOrderCards 未定义，使用旧方式');
                // 如果新渲染函数不可用，使用旧方式
                renderOldStyle(orders);
            }
        } catch (e) {
            console.error("解析订单数据失败:", e);
            console.error("原始数据:", data);
            $("#orders").html('<div style="text-align:center;padding:50px;color:#999;"><h3>数据加载失败</h3><p>错误信息：' + e.message + '</p></div>');
        }
    }).fail(function(xhr, status, error) {
        console.error("请求失败:", status, error);
        console.error("XHR:", xhr);
        $("#orders").html('<div style="text-align:center;padding:50px;color:#999;"><h3>加载失败，请刷新页面</h3><p>错误：' + error + '</p></div>');
    });
}
