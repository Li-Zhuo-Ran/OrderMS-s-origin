from django.db import migrations, models


def forward_status_value_mapping(apps, schema_editor):
    OrderItem = apps.get_model('OrderSystem', 'OrderItem')
    OrderItem.objects.filter(status__gte=1).update(status=models.F('status') + 1)


def backward_status_value_mapping(apps, schema_editor):
    OrderItem = apps.get_model('OrderSystem', 'OrderItem')
    OrderItem.objects.filter(status__gte=2).update(status=models.F('status') - 1)


class Migration(migrations.Migration):
    dependencies = [
        ('OrderSystem', '0003_alter_orderitem_status'),
    ]

    operations = [
        migrations.RunPython(
            forward_status_value_mapping,
            backward_status_value_mapping,
        ),
    ]
