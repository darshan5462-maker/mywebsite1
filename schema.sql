-- Create the gallery table
CREATE TABLE IF NOT EXISTS public.gallery (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT,
    caption TEXT,
    image_url TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('events', 'meetings', 'celebrations', 'programs')),
    event_date DATE,
    is_published BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS) on gallery
ALTER TABLE public.gallery ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can view published gallery items" ON public.gallery FOR SELECT USING (is_published = true);
CREATE POLICY "Admin can manage gallery items" ON public.gallery FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Create gallery storage
INSERT INTO storage.buckets (id, name, public) VALUES ('gallery_images', 'gallery_images', true) ON CONFLICT (id) DO NOTHING;
CREATE POLICY "Public can view gallery images" ON storage.objects FOR SELECT USING (bucket_id = 'gallery_images');
CREATE POLICY "Admin can upload images" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'gallery_images');
CREATE POLICY "Admin can update images" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'gallery_images');
CREATE POLICY "Admin can delete images" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'gallery_images');

-- ==========================================
-- NEW TABLES: CONTACTS AND MEMBERSHIPS
-- ==========================================

-- Contact Requests Table
CREATE TABLE IF NOT EXISTS public.contact_requests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.contact_requests ENABLE ROW LEVEL SECURITY;
-- Public can insert
CREATE POLICY "Public can insert contact requests" ON public.contact_requests FOR INSERT WITH CHECK (true);
-- Admin can view/delete
CREATE POLICY "Admin can manage contact requests" ON public.contact_requests FOR ALL TO authenticated USING (true) WITH CHECK (true);


-- Memberships Table
CREATE TABLE IF NOT EXISTS public.memberships (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    father_husband_name TEXT,
    gender TEXT,
    dob DATE,
    category TEXT,
    caste TEXT,
    qualification TEXT,
    profession TEXT,
    current_address TEXT,
    permanent_address TEXT,
    phone TEXT,
    panchayat TEXT,
    email TEXT,
    aadhaar TEXT,
    district TEXT,
    taluk TEXT,
    membership_type TEXT,
    membership_fee INTEGER,
    transaction_id TEXT,
    photo_storage_path TEXT,
    status TEXT DEFAULT 'Pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.memberships ENABLE ROW LEVEL SECURITY;
-- Public can insert
CREATE POLICY "Public can insert memberships" ON public.memberships FOR INSERT WITH CHECK (true);
-- Admin can view/update/delete
CREATE POLICY "Admin can manage memberships" ON public.memberships FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Create members_photos storage
INSERT INTO storage.buckets (id, name, public) VALUES ('members_photos', 'members_photos', true) ON CONFLICT (id) DO NOTHING;
-- Public can insert (needed for form upload without auth)
CREATE POLICY "Public can upload member photos" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'members_photos');
-- Admin can view/delete
CREATE POLICY "Admin can manage member photos" ON storage.objects FOR ALL TO authenticated USING (bucket_id = 'members_photos') WITH CHECK (bucket_id = 'members_photos');
