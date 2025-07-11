# Database Setup for Donation Registrations

## Table Schema

Run this SQL in your Supabase SQL Editor to create the `donation_registrations` table:

```sql
-- Create donation_registrations table
CREATE TABLE IF NOT EXISTS donation_registrations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    donation_request_id TEXT NOT NULL,
    donor_user_id TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('blood', 'hair', 'kidney', 'fund')),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE,

    -- Personal Information
    full_name TEXT NOT NULL,
    nic TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    gender TEXT,
    age INTEGER,
    date_of_birth DATE,

    -- Category-specific data stored as JSONB
    category_specific_data JSONB DEFAULT '{}',

    -- Additional fields
    notes TEXT,
    scheduled_date TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_donation_registrations_donation_request_id ON donation_registrations(donation_request_id);
CREATE INDEX IF NOT EXISTS idx_donation_registrations_donor_user_id ON donation_registrations(donor_user_id);
CREATE INDEX IF NOT EXISTS idx_donation_registrations_category ON donation_registrations(category);
CREATE INDEX IF NOT EXISTS idx_donation_registrations_status ON donation_registrations(status);
CREATE INDEX IF NOT EXISTS idx_donation_registrations_created_at ON donation_registrations(created_at);

-- Enable Row Level Security (RLS)
ALTER TABLE donation_registrations ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users to insert their own registrations
CREATE POLICY "Users can insert their own donation registrations" ON donation_registrations
    FOR INSERT WITH CHECK (auth.uid()::text = donor_user_id);

-- Create policy for authenticated users to view their own registrations
CREATE POLICY "Users can view their own donation registrations" ON donation_registrations
    FOR SELECT USING (auth.uid()::text = donor_user_id);

-- Create policy for admins to view all registrations (optional - adjust as needed)
-- CREATE POLICY "Admins can view all donation registrations" ON donation_registrations
--     FOR SELECT USING (auth.jwt() ->> 'role' = 'admin');

-- Create policy for admins to update all registrations (optional - adjust as needed)
-- CREATE POLICY "Admins can update donation registrations" ON donation_registrations
--     FOR UPDATE USING (auth.jwt() ->> 'role' = 'admin');
```

## Category-Specific Data Examples

### Blood Donation

```json
{
  "bloodGroup": "O+",
  "hasDonatedBefore": true,
  "lastDonationDate": "12/01/2024",
  "bloodPressure": "120/80",
  "hemoglobin": "13.5",
  "hasCurrentMedication": false,
  "medicationDetails": ""
}
```

### Hair Donation

```json
{
  "hairLength": "12 inches",
  "hasGreyHair": false,
  "additionalNotes": "Natural hair, no treatments",
  "selectedSalon": "Hair Care Center",
  "pickupAddress": "123 Main St",
  "preferredDate": "15/01/2024",
  "preferredTime": "10:00 AM",
  "requestCertificate": true,
  "certificateEmail": "donor@email.com"
}
```

### Kidney Donation

```json
{
  "emergencyContact": "John Doe",
  "emergencyPhone": "+94701234567",
  "selectedBloodGroup": "O+",
  "recipientRelation": "Brother",
  "height": "175cm",
  "weight": "70kg",
  "hasChronicDiseases": false,
  "chronicDiseases": "",
  "hasPreviousSurgeries": false,
  "surgeries": "",
  "hasCurrentMedication": false,
  "medicationDetails": "",
  "hasAllergies": false,
  "allergies": "",
  "smoker": false,
  "alcoholConsumer": false
}
```

### Fund Donation

```json
{
  "donorName": "Jane Smith",
  "donorEmail": "jane@email.com",
  "donorPhone": "+94701234567",
  "donationAmount": "5000",
  "selectedPaymentMethod": "Online Payment (Card)",
  "amountRequested": "10000",
  "reason": "Medical treatment",
  "paymentComplete": true,
  "transactionId": "TXN1642123456789"
}
```

## Usage Notes

1. The `donation_request_id` should link to your existing donation requests table
2. The `donor_user_id` should be the authenticated user's ID from Supabase Auth
3. Category-specific data is stored as JSONB for flexibility
4. Row Level Security ensures users can only access their own registrations
5. Additional admin policies can be added as needed

## Integration

The app uses the `DonationRegistrationProvider` and `DonationRegistrationService` to:

- Create new donation registrations
- Fetch registrations by user, category, or status
- Update registration status and scheduled dates
- Search and filter registrations

All donation forms (blood, hair, kidney, fund) now save registrations to this table with a "pending" status.
