from django.test import SimpleTestCase

from .models import OrderItem


class KitchenStatusTransitionTests(SimpleTestCase):
    def test_valid_status_transition_chain(self):
        order_item = OrderItem(status=OrderItem.KitchenStatus.PENDING)
        order_item.transition_to(OrderItem.KitchenStatus.ACCEPTED)
        self.assertEqual(order_item.status, OrderItem.KitchenStatus.ACCEPTED)

        order_item.transition_to(OrderItem.KitchenStatus.COOKING)
        self.assertEqual(order_item.status, OrderItem.KitchenStatus.COOKING)

        order_item.transition_to(OrderItem.KitchenStatus.READY_TO_SERVE)
        self.assertEqual(order_item.status, OrderItem.KitchenStatus.READY_TO_SERVE)

        order_item.transition_to(OrderItem.KitchenStatus.SERVED)
        self.assertEqual(order_item.status, OrderItem.KitchenStatus.SERVED)

    def test_invalid_status_transition_raises_error(self):
        order_item = OrderItem(status=OrderItem.KitchenStatus.PENDING)
        with self.assertRaisesMessage(ValueError, "非法状态流转"):
            order_item.transition_to(OrderItem.KitchenStatus.SERVED)
